resource "vault_mount" "static" {
  path        = "secret"
  type        = "kv-v2"
  description = "static secret engine"
}