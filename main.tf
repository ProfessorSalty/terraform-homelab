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
      ssd     = lookup(disk.value, "ssd", 0)
      type    = "scsi"
      format  = "qcow2"
    }
  }

  provisioner "remote-exec" {
    count  = var.hostname == "" ? [0] : [1]
    inline = ["sudo hostnamectl set-hostname ${var.hostname}"]

    connection {
      type     = "ssh"
      user     = var.ssh_user
      password = var.ssh_password
    }
  }

}
