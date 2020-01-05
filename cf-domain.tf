# resource "cloudflare_zone" "qm64_tech" {
# 	zone = "qm64.tech"
# }

# if Zone does exists:
data "cloudflare_zones" "qm64_tech" {
  filter {
    name = "qm64.tech"
  }
}


resource "cloudflare_record" "qm64_tech_vault" {
  zone_id = lookup(data.cloudflare_zones.qm64_tech.zones[0], "id")
  name    = "vault"
  type    = "A"
  value   = "116.203.249.221" # Manual

  ttl     = "1"
  proxied = true
}

