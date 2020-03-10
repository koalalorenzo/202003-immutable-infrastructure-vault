api_addr = "https://${qm64_vault_domain}"
ui = true

listener "tcp" {
  address     = "0.0.0.0:443"
  tls_cert_file = "/etc/vault/tls/server.crt"
  tls_key_file = "/etc/vault/tls/server.key"
}

storage "s3" {
  bucket     = "${vault_s3_bucket_name}"
  region     = "${vault_s3_bucket_region}"
}