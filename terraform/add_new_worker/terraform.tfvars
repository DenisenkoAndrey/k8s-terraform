prefix = "terraform"

pool_name = "terraformpool"

image = {
  name   = "k8s_cluster"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

domains = {
  name = "_new_worker_1"
  cpu  = 1
  ram  = 1024
  disk = 20 * 1024 * 1024 * 1024
}

ips = ["192.168.100.104"]

name_cloudinit = "cloudint_for_new_worker"

base_volume_id = "/var/lib/libvirt/terraformpool/k8s_cluster"

