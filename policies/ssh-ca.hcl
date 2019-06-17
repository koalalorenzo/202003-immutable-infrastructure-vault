# This policies provide access only to the CA
path "ssh/config/ca" {
  capabilities = ["read", "list"]
}
