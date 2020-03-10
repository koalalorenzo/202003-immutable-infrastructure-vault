resource "vault_policy" "packer" {
  name = "packer"

  policy = <<EOT
# AWS Access
path "aws/creds/*" {
  capabilities = ["read"]
}
path "sys/leases/revoke/aws/creds/*" {
  capabilities = ["create", "update", "read"]
}

# Packer requirements
path "secret/data/qm64/providers" {
  capabilities = ["read", "list"]
}

# Issue certificates
path "pki/issue/*" {
  capabilities = ["read", "create", "update"]
}

# Read secrets
path "secret/*" {
  capabilities = ["list"]
}

path "secret/data/*" {
  capabilities = ["read", "list"]
}
EOT
}