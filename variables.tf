variable "hcloud_token" {
  type    = string
  sensitive = true
}

variable "server_name" {
  type    = string
  default = "testvm1"
}

variable "location" {
  type    = string
  default = "ash"
}

variable "server_type" {
  type    = string
  default = "cpx11"
}

variable "server_image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "ssh_key_name" {
  type    = string
  default = "testvm-sshkey"
}

variable "ssh_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  type    = number
  default = 55022
}

variable "firewall_name" {
  type    = string
  default = "testvm-firewall"
}
