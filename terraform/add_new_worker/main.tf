resource "libvirt_volume" "root" {
  name           = "${var.prefix}${var.domains.name}-root"
  pool           = var.pool_name
  base_volume_id = var.base_volume_id
  size           = var.domains.disk
}

resource "libvirt_cloudinit_disk" "add_new_worker" {
  name      = "${var.name_cloudinit}.iso"
  pool      = var.pool_name
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_domain" "vm" {
  name   = "${var.prefix}${var.domains.name}"
  vcpu   = var.domains.cpu
  memory = var.domains.ram

  cloudinit = libvirt_cloudinit_disk.add_new_worker.id

  disk {
    volume_id = libvirt_volume.root.id
  }

  network_interface {
    addresses      = var.ips
    network_name   = "k8s_terraform"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}
