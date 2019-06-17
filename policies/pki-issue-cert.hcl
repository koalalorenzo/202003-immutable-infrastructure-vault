# This policy allows to generate certificates

path "pki/issue/*" {
  capabilities = ["read", "create", "update"]
}
