output "instance_ip" {
  value = proxmox_vm_qemu.proxmox_resource.ssh_host
}