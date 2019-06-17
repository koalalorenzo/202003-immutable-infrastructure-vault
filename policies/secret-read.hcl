## STARTS CUSTOM ##

path "secret/*" {
  capabilities = ["list"]
}

path "secret/data/*" {
  capabilities = ["read", "list"]
}

path "transit/decrypt/*" {
  capabilities = ["create", "update", "read"]
}
