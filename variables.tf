variable "pm_user" {
  type        = string
  description = "Username and login source for the Proxmox user Terraform will use (username@source)"
  default     = "terraform@pve"
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
  description = "Which provisioning method to use, based on the OS type. ubuntu | centos | cloud-init"
  default     = "ubuntu"
}

variable "vmid" {
  type = number
}

variable "disks" {
  description = "Always include the DUMMY_DRIVE at the beginning to prevent changing the template's default drive"
  type = list(object({
    size    = string
    storage = string
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
