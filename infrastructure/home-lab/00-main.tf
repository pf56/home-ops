terraform {
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16"
    }

    proxmox = {
      source  = "bpg/proxmox"
      version = "0.108.0"
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

provider "proxmox" {
  endpoint  = "https://pve.internal.paulfriedrich.me:8006/"
  api_token = local.credentials["proxmox_token"]

  # because self-signed TLS certificate is in use
  insecure      = true
  random_vm_ids = true
}

locals {
  credentials = {
    proxmox_token = ephemeral.infisical_secret.proxmox_token.value
  }
}

resource "proxmox_virtual_environment_vm" "infisical" {
  name = "infisical"
  tags = ["tofu", "nixos"]

  node_name       = var.pve_node_name
  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  efi_disk {
    datastore_id = var.pve_datastore_id
    type         = "4m"
  }

  disk {
    datastore_id = var.pve_datastore_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
