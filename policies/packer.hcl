
path "secret/data/infrastructure" {
  capabilities = ["read", "list"]
}

# AWS Access
path "aws/creds/packer" {
  capabilities = ["read"]
}

path "sys/leases/revoke/aws/creds/packer/*" {
  capabilities = ["create", "update", "read"]
}
