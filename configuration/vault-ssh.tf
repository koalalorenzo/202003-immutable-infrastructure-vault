resource "vault_mount" "ssh" {
  type                  = "ssh"
  path                  = "ssh"
  max_lease_ttl_seconds = 60 * 60 # 1h
}

resource "vault_ssh_secret_backend_ca" "ssh_ca" {
  backend              = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ssh_admin" {
  name                    = "admin"
  backend                 = vault_mount.ssh.path
  key_type                = "ca"
  default_user            = "root"
  allowed_users           = "*"
  allow_user_certificates = true
  ttl                     = 60 * 30 # 3 min
}