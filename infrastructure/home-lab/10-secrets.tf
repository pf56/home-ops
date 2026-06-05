ephemeral "infisical_secret" "proxmox_token" {
  name         = "api-token"
  env_slug     = var.environment
  workspace_id = var.infisical_project_id
  folder_path  = "/proxmox"
}

