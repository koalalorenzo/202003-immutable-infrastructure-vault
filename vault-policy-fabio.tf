                  


resource "vault_policy" "fabiolb" {
  name = "fabiolb"

  policy = <<EOT
# Allow to issue certificates
path "pki/issue/*" {
  capabilities = ["update"]
}

# The following capabilities are typically provided by Vault's default policy.
path "auth/token/lookup-self" {
    capabilities = ["read"]                
}                   
path "auth/token/renew-self" {
    capabilities = ["update"]                                        
}       
EOT
}