terraform {
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "infisical" {
  host = var.infisical_url
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}

provider "hcloud" {
  token = local.credentials["hcloud_token"]
}

provider "cloudflare" {
  api_token = local.credentials["cloudflare_token"]
}

ephemeral "infisical_secret" "hcloud_token" {
  name         = "token"
  env_slug     = var.environment
  workspace_id = var.infisical_project_id
  folder_path  = "/hcloud"
}

ephemeral "infisical_secret" "cloudflare_token" {
  name         = "token"
  env_slug     = var.environment
  workspace_id = var.infisical_project_id
  folder_path  = "/cloudflare"
}

locals {
  credentials = {
    hcloud_token     = ephemeral.infisical_secret.hcloud_token.value
    cloudflare_token = ephemeral.infisical_secret.cloudflare_token.value
  }
}

resource "hcloud_network" "main" {
  name     = "main"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "main" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_firewall" "main" {
  name = "main"

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "21820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_ssh_key" "ssh_keys" {
  for_each   = { for index, key in var.ssh_keys : key.name => key }
  name       = each.value.name
  public_key = each.value.key
}

resource "hcloud_server" "pangolin" {
  name        = "pangolin"
  server_type = "cx23"
  location    = "nbg1"
  image       = "debian-13"

  ssh_keys     = [for key in hcloud_ssh_key.ssh_keys : key.id]
  firewall_ids = [hcloud_firewall.main.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.main.id
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [
      ssh_keys
    ]
  }

  depends_on = [
    hcloud_network_subnet.main
  ]
}

resource "cloudflare_dns_record" "pangolin_domain1_v4" {
  zone_id = var.cloudflare_domain1_zone_id
  name    = "ext"
  ttl     = 3600
  type    = "A"
  content = hcloud_server.pangolin.ipv4_address
}

resource "cloudflare_dns_record" "pangolin_domain1_v6" {
  zone_id = var.cloudflare_domain1_zone_id
  name    = "ext"
  ttl     = 3600
  type    = "AAAA"
  content = hcloud_server.pangolin.ipv6_address
}

resource "cloudflare_dns_record" "pangolin_domain1_wildcard_v4" {
  zone_id = var.cloudflare_domain1_zone_id
  name    = "*.ext"
  ttl     = 3600
  type    = "A"
  content = hcloud_server.pangolin.ipv4_address
}

resource "cloudflare_dns_record" "pangolin_domain1_wildcard_v6" {
  zone_id = var.cloudflare_domain1_zone_id
  name    = "*.ext"
  ttl     = 3600
  type    = "AAAA"
  content = hcloud_server.pangolin.ipv6_address
}

resource "cloudflare_dns_record" "pangolin_domain2_v4" {
  zone_id = var.cloudflare_domain2_zone_id
  name    = "@"
  ttl     = 3600
  type    = "A"
  content = hcloud_server.pangolin.ipv4_address
}

resource "cloudflare_dns_record" "pangolin_domain2_v6" {
  zone_id = var.cloudflare_domain2_zone_id
  name    = "@"
  ttl     = 3600
  type    = "AAAA"
  content = hcloud_server.pangolin.ipv6_address
}

resource "cloudflare_dns_record" "pangolin_domain2_wildcard_v4" {
  zone_id = var.cloudflare_domain2_zone_id
  name    = "*"
  ttl     = 3600
  type    = "A"
  content = hcloud_server.pangolin.ipv4_address
}

resource "cloudflare_dns_record" "pangolin_domain2_wildcard_v6" {
  zone_id = var.cloudflare_domain2_zone_id
  name    = "*"
  ttl     = 3600
  type    = "AAAA"
  content = hcloud_server.pangolin.ipv6_address
}

output "pangolin_ip_addr" {
  value = hcloud_server.pangolin.ipv4_address
}
