output "vms_info" {
  value = [
    for vm in libvirt_domain.vm : {
      name = vm.name
      ip   = vm.network_interface[0].addresses.0
    }
  ]
}
