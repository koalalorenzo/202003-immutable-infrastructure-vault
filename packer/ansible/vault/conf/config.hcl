api_addr = "https://vault.qm64.tech"
ui = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1

  # Generate TLS certificates only at deployment time. 
  # DO NOT PACK certificates inside an image!
  #tls_cert_file = "/etc/vault/tls/server.crt"
  #tls_key_file = "/etc/vault/tls/server.key"
}

# Default Config, It should be modified by Cloud Init
storage "file" {
  path = "/var/vault"
}