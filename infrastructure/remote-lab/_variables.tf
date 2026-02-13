variable "environment" {
}

variable "ssh_keys" {
  type        = list(object({ name = string, key = string }))
  default     = []
  description = "SSH keys to register on hcloud"
}

variable "infisical_url" {
}

variable "infisical_client_id" {
}

variable "infisical_client_secret" {
  sensitive = true
  ephemeral = true
}

variable "infisical_project_id" {
}

variable "cloudflare_domain1_zone_id" {
  type = string
}

variable "cloudflare_domain2_zone_id" {
  type = string
}
