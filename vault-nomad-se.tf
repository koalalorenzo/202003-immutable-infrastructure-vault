# Secret Engine for Nomad, this generates ACL based on tokens
variable "nomad_addr" {}
variable "nomad_token" {}

resource "vault_mount" "nomad" {
  path                      = "nomad"
  type                      = "nomad"
  default_lease_ttl_seconds = 24 * 60 * 60      # ~ a day
  max_lease_ttl_seconds     = 31 * 24 * 60 * 60 # ~ a month
}

resource "vault_generic_secret" "nomad_config" {
  depends_on = [vault_mount.nomad]
  path       = "nomad/config/lease"

  data_json = <<EOT
{
  "ttl":   "86400",
  "max_ttl": "2678400"
}
EOT
}

resource "vault_generic_secret" "nomad_access" {
  depends_on = [vault_generic_secret.nomad_config]
  path       = "nomad/config/access"

  data_json = <<EOT
{
  "address": "${var.nomad_addr}",
  "token": "${var.nomad_token}"
}
EOT
}

resource "vault_generic_secret" "nomad_policy_monitoring" {
  depends_on = [vault_generic_secret.nomad_access]
  path       = "nomad/role/monitoring"

  data_json = <<EOT
{
  "policies": "readonly",
  "global": "true"
}
EOT
}

resource "vault_generic_secret" "nomad_policy_admin" {
  depends_on = [vault_generic_secret.nomad_access]
  path       = "nomad/role/admin"

  data_json = <<EOT
{
  "policies": "admin",
  "global": "true"
}
EOT
}