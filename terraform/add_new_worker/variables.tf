variable "prefix" {
  type    = string
  default = "terraform"
}

variable "pool_name" {
  type    = string
  default = "terraformpool"
}

variable "image" {
  type = object({
    name   = string
    source = string
  })
}

variable "domains" {
  type = object({
    name = string,
    cpu  = number,
    ram  = number,
    disk = number,
  })
}

variable "ips" {
  type = list(any)
}

variable "name_cloudinit" {
  type    = string
  default = "new_worker.iso"
}

variable "base_volume_id" {
  type    = string
  default = "/var/lib/libvirt/terraformpool/k8s_cluster"
}
