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

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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

  talos_control_plane_nodes = {
    for i in range(3) :
    format("%02d", i + 1) => "talos-control"
  }

  talos_worker_nodes = {
    for i in range(3) :
    format("%02d", i + 1) => "talos-worker"
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
    type  = "host"
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

resource "proxmox_virtual_environment_vm" "monitoring" {
  name = "monitoring"
  tags = ["tofu", "nixos"]

  node_name       = var.pve_node_name
  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 4096
    floating  = 4096
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
    size         = 40
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

resource "proxmox_virtual_environment_vm" "homeassistant" {
  name = "homeassistant"
  tags = ["tofu"]

  node_name       = var.pve_node_name
  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 4096
    floating  = 4096
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
    size         = 32
  }

  network_device {
    bridge = "vmbr040"
  }
}

resource "random_string" "talos_control_plane_suffix" {
  for_each = local.talos_control_plane_nodes

  length  = 4
  upper   = false
  special = false
}

resource "proxmox_virtual_environment_vm" "talos_control_plane" {
  for_each = local.talos_control_plane_nodes

  name = "${each.value}-${random_string.talos_control_plane_suffix[each.key].result}"
  tags = ["tofu", "talos"]

  node_name       = var.pve_node_name
  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
    floating  = 4096
  }

  tpm_state {
    datastore_id = var.pve_datastore_id
    version      = "v2.0"
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

  network_device {
    bridge = "vmbr0"
  }
}

resource "random_string" "talos_worker_suffix" {
  for_each = local.talos_worker_nodes

  length  = 4
  upper   = false
  special = false
}

resource "proxmox_virtual_environment_vm" "talos_worker" {
  for_each = local.talos_worker_nodes

  name = "${each.value}-${random_string.talos_worker_suffix[each.key].result}"
  tags = ["tofu", "talos"]

  node_name       = var.pve_node_name
  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true

  cpu {
    cores = 8
    type  = "host"
  }

  memory {
    dedicated = 8192
    floating  = 8192
  }

  tpm_state {
    datastore_id = var.pve_datastore_id
    version      = "v2.0"
  }

  efi_disk {
    datastore_id = var.pve_datastore_id
    type         = "4m"
  }

  # system
  disk {
    datastore_id = var.pve_datastore_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  # longhorn storage
  disk {
    datastore_id = var.pve_datastore_id
    interface    = "virtio1"
    serial       = "lh${random_string.talos_worker_suffix[each.key].result}"
    iothread     = true
    discard      = "on"
    size         = 128
  }

  network_device {
    bridge = "vmbr0"
  }
}
