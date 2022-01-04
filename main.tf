terraform {
  experiments = [module_variable_optional_attrs]
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

locals {
  proxmox_server_protocol = "https"
  proxmox_server_port     = 8006
}

provider "proxmox" {
  pm_user             = var.proxmox_user
  pm_api_token_id     = var.proxmox_token.id
  pm_api_token_secret = var.proxmox_token.secret
  pm_api_url          = "${local.proxmox_server_protocol}://${var.proxmox_host}:${local.proxmox_server_port}/api2/json"
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
  oncreate    = true
  full_clone  = false
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