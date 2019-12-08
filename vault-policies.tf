resource "vault_policy" "pipeline" {
  name = "pipeline"

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

path "transit/decrypt/*" {
  capabilities = ["create", "update", "read"]
}

# Token specific stuff (used by Terraform)
path "auth/token/create" {
  capabilities = ["create", "update", "read"]
}

# Mount points (used by Terraform)
path "sys/mounts/*" {
  capabilities = ["read", "update", "sudo", "list"]
}

# Ability to rotate keys
path "postgres/rotate-root/*"{
  capabilities = ["create", "update", "read", "list"]
}

# Allow the Pipeline to seal vault in case of emergencies
path "sys/seal"
{
  capabilities = ["read", "update", "sudo"]
}
EOT
}