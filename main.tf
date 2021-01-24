terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_password     = var.pm_user_pass
  pm_api_url      = var.pm_api_url
}

resource "proxmox_vm_qemu" "proxmox_resource" {
  name        = var.name
  target_node = var.target_node
  vmid        = var.vmid
  clone       = var.clone_source
  cores       = var.cores
  memory      = var.memory
  os_type     = var.os_type
  balloon     = 2048
  onboot      = true
  full_clone  = false
  boot        = "c"
  agent       = 1
  hotplug     = "network,disk,cpu"
  ipconfig0   = "ip=dhcp"

  dynamic "network" {
    for_each = var.networks
    content {
      model  = "virtio"
      bridge = network.value["bridge"]
    }
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      size    = disk.value["size"]
      storage = disk.value["storage"]
      format  = lookup(disk.value, "format", "qcow2")
      ssd     = lookup(disk.value, "ssd", 0)
      type    = "scsi"
    }
  }
}

resource "null_resource" "wait_for_reboot" {
  count = var.vm_playbook_dir == "" ? 0 : 1
  depends_on = [proxmox_vm_qemu.proxmox_resource]

  provisioner "local-exec" {
    command     = "${path.module}/wait_port ${proxmox_vm_qemu.proxmox_resource.ssh_host} ${proxmox_vm_qemu.proxmox_resource.ssh_port}"
  }
}

resource "null_resource" "run_ansible_setup" {
  count = var.vm_playbook_dir == "" ? 0 : 1
  depends_on = [null_resource.wait_for_reboot]

  provisioner "local-exec" {
    command = "ansible-playbook -i ${proxmox_vm_qemu.proxmox_resource.ssh_host}, ${var.vm_playbook_dir}/${var.name}/${var.playbook_filename}}"
  }
}