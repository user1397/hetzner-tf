terraform {

  required_version = ">= 1.4.6"

  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = file(var.ssh_key_path)
}

resource "hcloud_server" "testvm" {
  name           = var.server_name
  image          = var.server_image
  server_type    = var.server_type
  location       = var.location
  user_data      = file("cloud-init.sh")
  ssh_keys       = [ hcloud_ssh_key.default.id ]
  firewall_ids   = [ hcloud_firewall.myfirewall.id ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
}

# optional: uncomment if you want a floating IP in addition
# to the primary IP of the server
#resource "hcloud_floating_ip" "floatingip" {
#  type      = "ipv4"
#  server_id = hcloud_server.testvm.id
#}

# Grab local public IP
data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}

resource "hcloud_firewall" "myfirewall" {
  name = var.firewall_name
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [ "${data.http.my_ip.response_body}/32" ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = var.ssh_port
    source_ips = [ "${data.http.my_ip.response_body}/32" ]
  }

  rule {
    direction = "out"
    protocol  = "tcp"
    port      = "any"
    destination_ips = [ "0.0.0.0/0" ]
  }

  rule {
    direction = "out"
    protocol  = "udp"
    port      = "any"
    destination_ips = [ "0.0.0.0/0" ]
  }

  rule {
    direction = "out"
    protocol  = "icmp"
    destination_ips = [ "0.0.0.0/0" ]
  }

}