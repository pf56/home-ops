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
