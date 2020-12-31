variable "pm_user" {
  type        = string
  description = "Username and login source for the Proxmox user Terraform will use (username@source)"
  default     = "terraform@pve"
}

variable "proxmox_ip" {
  type        = string
  description = "IP address and port of the Proxmox server. Do not enter path or protocol"
  default     = ""
}

variable "name" {
    type = string
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
    type = string
}

variable "vmid" {
    type = number
}

variable "disks" {
    type = list(object({
        size         = string
        storage      = string
    }))
    default = []
}

variable "networks" {
    type = list(object({
        bridge = string
    }))
    default = []
}