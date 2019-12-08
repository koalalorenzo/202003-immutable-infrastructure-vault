resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  default_lease_ttl_seconds = 31 * 24 * 60 * 60 # ~ a month
  max_lease_ttl_seconds     = 8760 * 60 * 60    # ~ a year
}


resource "vault_pki_secret_backend_config_urls" "pki_config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["https://vault.qm64.tech/v1/pki/ca"]
  crl_distribution_points = ["https://vault.qm64.tech/v1/pki/crl"]
}

resource "vault_pki_secret_backend_role" "qm64" {
  backend            = vault_mount.pki.path
  name               = "qm64.tech"
  allowed_domains    = ["qm64.tech"]
  allow_subdomains   = true
  allow_glob_domains = true
  max_ttl            = 8760 * 60 * 60
}

resource "vault_pki_secret_backend_role" "siderus" {
  backend            = vault_mount.pki.path
  name               = "siderus.io"
  allowed_domains    = ["siderus.io", "siderus.team", "ipfs.rocks"]
  allow_subdomains   = true
  allow_glob_domains = true
  max_ttl            = 8760 * 60 * 60
}
