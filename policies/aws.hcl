# AWS Access
path "aws/creds/*" {
  capabilities = ["read"]
}

path "sys/leases/revoke/aws/creds/*" {
  capabilities = ["create", "update", "read"]
}
