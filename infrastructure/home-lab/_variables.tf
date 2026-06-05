variable "environment" {
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

variable "pve_node_name" {
}

variable "pve_datastore_id" {
}
