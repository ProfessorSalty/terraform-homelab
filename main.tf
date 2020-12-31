terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
    pm_user         = var.pm_user
    pm_api_url      = "https://${var.proxmox_ip}/api2/json"
    pm_tls_insecure = true
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

  dynamic network {
    for_each = var.networks
    content {
        model  = "virtio"
        bridge = network.value["bridge"]
    }
  }

  dynamic disk {
    for_each = var.disks
    content {
        slot         = disk.key + 1
        size         = disk.value["size"]
        storage      = disk.value["storage"]
        ssd          = lookup(disk.value, "ssd", true)
        type         = "scsi"
        format       = "qcow2"
    }
  }
} 