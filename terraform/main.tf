resource "libvirt_network" "k8s_terraform" {
  name      = "k8s_terraform"
  mode      = "nat"
  domain    = "test.local"
  addresses = ["192.168.100.0/24"]
  dhcp {
    enabled = true
  }
}

resource "libvirt_pool" "pool" {
  name = "${var.prefix}pool"
  type = "dir"
  path = "${var.pool_path}${var.prefix}pool"
}

resource "libvirt_volume" "image" {
  name   = var.image.name
  format = "qcow2"
  pool   = libvirt_pool.pool.name
  source = var.image.source
}

resource "libvirt_volume" "root" {
  count          = length(var.domains)
  name           = "${var.prefix}${var.domains[count.index].name}-root"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.image.id
  size           = var.domains[count.index].disk
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = libvirt_pool.pool.name
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_domain" "vm" {
  count  = length(var.domains)
  name   = "${var.prefix}${var.domains[count.index].name}"
  vcpu   = var.domains[count.index].cpu
  memory = var.domains[count.index].ram

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.root[count.index].id
  }

  network_interface {
    addresses      = [element(var.ips, count.index)]
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



