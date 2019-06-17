# This policy gives access to servers via SSH
path "ssh/config/ca" {
  capabilities = ["read", "list"]
}

path "ssh/sign/*" {
  capabilities = ["read", "create", "update"]
}
