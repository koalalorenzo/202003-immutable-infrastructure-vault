
# This policy is designed for the IPFS Gateway
path "secret/ipfs/*" {
  capabilities = ["read", "list"]
}


path "transit/decrypt/meta.siderus.io" {
  capabilities = ["create", "update", "read"]
}
