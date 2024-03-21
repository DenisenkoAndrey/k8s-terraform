variable "prefix" {
  type    = string
  default = "terraform"
}

variable "pool_path" {
  type    = string
  default = "/var/lib/libvirt/"
}

variable "image" {
  type = object({
    name   = string
    source = string
  })
}

variable "domains" {
  type = list(object({
    name = string,
    cpu  = number,
    ram  = number,
    disk = number,
  }))
}

variable "ips" {
  type = list(any)
}

