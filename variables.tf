variable "proxmox_token" {
  sensitive = true
  type      = object({
    id = string
    secret = string
  })
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_user" {
  type = string
  validation {
    condition = can(regex("@(pam|pve)$", var.proxmox_user))
    error_message = "Please enter the full username with the authentication domain (@pve, @pam, etc.)."
  }
}

variable "name" {
  description = "Name of the VM in Proxmox"
  type        = string
}

variable "target_node" {
  type = string
}

variable "clone_source" {
  type        = string
  description = "Template that we will clone from"
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 2048
}

variable "streaming_bridge" {
  type        = string
  description = "The network bridge this VM will use"
  default     = "vmbr0"
}

variable "os_type" {
  type        = string
  description = "Which provisioning method to use, based on the OS type. ubuntu (Default) | centos | cloud-init"
  default     = "ubuntu"
}

variable "vmid" {
  type = number
}

variable "disks" {
  type = list(object({
    size    = string
    storage = string
    ssd     = optional(number)
    format  = optional(string)
  }))
  default = []
}

variable "networks" {
  type = list(object({
    bridge = string
  }))
  default = []
}

variable "ssd" {
  type    = bool
  default = false
}

variable "hostname" {
  type    = string
  default = ""
}