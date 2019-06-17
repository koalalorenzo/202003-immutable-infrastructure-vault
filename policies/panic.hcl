# This policy allows to rotate keys and seal
# It is meant for panic mode.


path "postgres/rotate-root/*"{
  capabilities = ["create", "update", "read", "list"]
}

# Allow the Pipeline to seal vault
path "sys/seal"
{
  capabilities = ["read", "update", "sudo"]
}
