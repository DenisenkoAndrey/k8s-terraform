prefix = "terraform"

pool_path = "/var/lib/libvirt/"

image = {
  name   = "k8s_cluster"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

domains = [
  {
    name = "master"
    cpu  = 1
    ram  = 1024
    disk = 20 * 1024 * 1024 * 1024
  },
  {
    name = "worker_1"
    cpu  = 1
    ram  = 1024
    disk = 20 * 1024 * 1024 * 1024
  },
  {
    name = "worker_2"
    cpu  = 1
    ram  = 1024
    disk = 20 * 1024 * 1024 * 1024
  }
]

ips = [
  "192.168.100.101",
  "192.168.100.102",
  "192.168.100.103"
]
