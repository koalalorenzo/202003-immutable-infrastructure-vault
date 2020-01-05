resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "siderus-meta" {
  backend = vault_mount.transit.path
  name    = "meta.siderus.io"
}