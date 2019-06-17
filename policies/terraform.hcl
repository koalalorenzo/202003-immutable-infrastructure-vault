
path "secret/data/infrastructure" {
  capabilities = ["read", "list"]
}


# Token specific stuff (used by Terraform)
path "auth/token/create" {
  capabilities = ["create", "update", "read"]
}

# Mount points (used by Terraform)
path "sys/mounts/*" {
  capabilities = ["read", "update", "sudo", "list"]
}

# GCP Access
path "gcp/key/admin" {
  capabilities = ["read"]
}

# AWS Access
path "aws/creds/admin" {
  capabilities = ["read"]
}
