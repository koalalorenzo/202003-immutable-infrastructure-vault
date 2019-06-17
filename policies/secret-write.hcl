
path "secret/*" {
  capabilities = ["create", "update", "list"]
}

path "secret/data/*" {
  capabilities = ["create", "update", "list"]
}

path "transit/encrypt/*" {
  capabilities = ["create", "update", "read"]
}
