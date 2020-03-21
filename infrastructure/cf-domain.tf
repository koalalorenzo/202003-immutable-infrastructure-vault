# resource "cloudflare_zone" "qm64_tech" {
# 	zone = "qm64.tech"
# }

# Qm64 zone on cloudflare already exists, so we don't have to create a new one
data "cloudflare_zones" "qm64_tech" {
  filter {
    name = "qm64.tech"
  }
}

resource "cloudflare_record" "qm64_tech_vault" {
  zone_id = lookup(data.cloudflare_zones.qm64_tech.zones[0], "id")
  name    = "vault"
  type    = "A"
  value   = aws_instance.vault.public_ip 

  # By proxying it we do not expose the IP but we also ensure that the IP
  # changes are propagated "faster" than DNS cache. Be careful with the TTL if
  # proxy is disabled. :-)
  ttl     = "1"
  proxied = true
}

