# AWS Access
path "aws/creds/reader" {
  capabilities = ["read"]
}
path "sys/leases/revoke/aws/creds/reader/*" {
  capabilities = ["create", "update", "read"]
}
