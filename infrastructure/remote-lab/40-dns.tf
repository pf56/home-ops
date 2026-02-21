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

