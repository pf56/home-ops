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

locals {
  credentials = {
    hcloud_token     = ephemeral.infisical_secret.hcloud_token.value
    cloudflare_token = ephemeral.infisical_secret.cloudflare_token.value
  }
}

resource "hcloud_ssh_key" "ssh_keys" {
  for_each   = { for index, key in var.ssh_keys : key.name => key }
  name       = each.value.name
  public_key = each.value.key
}

output "pangolin_ip_addr" {
  value = hcloud_server.pangolin.ipv4_address
}
