package_upgrade: true
write_files:
  - content: |
      ${vault_configuration_b64}
    encoding: b64
    owner: vault:vault
    path: /etc/vault/config.hcl
    permissions: '0644'
  - content: |
      [req]
      distinguished_name=req
      [san]
      subjectAltName=DNS:${qm64_vault_domain}
    owner: vault:vault
    path: /etc/vault/tls/request
    permissions: '0644'
runcmd:
  - "openssl req -x509 -newkey rsa:4096 -sha512 -days 90 -nodes -keyout /etc/vault/tls/server.key -out /etc/vault/tls/server.crt -extensions san -config /etc/vault/tls/request -subj /CN=${qm64_vault_domain}"
  - "chown vault:vault /etc/vault/tls/*"
  - "chmod 0644 /etc/vault/tls/*"