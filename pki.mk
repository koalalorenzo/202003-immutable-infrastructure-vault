pki:
	-vault secrets enable pki
	vault secrets tune -max-lease-ttl=8760h pki # 1 year max lease
	vault write pki/config/urls \
    issuing_certificates="${VAULT_ADDR}v1/pki/ca" \
    crl_distribution_points="${VAULT_ADDR}v1/pki/crl"
	vault write pki/root/generate/internal common_name=siderus.team ttl=8760h
.PHONY: pki

pki_roles:
	# Defines roles that will last 1 year as max_ttl
	# siderus.io
	vault write pki/roles/siderus.io \
    allowed_domains=siderus.io \
		allow_glob_domains=true \
    allow_subdomains=true \
    max_ttl=8928h
	# siderus.team
	vault write pki/roles/siderus.team \
    allowed_domains=siderus.team \
    allow_subdomains=true \
		allow_glob_domains=true \
    max_ttl=8928h
	# ipfs.rocks
	vault write pki/roles/ipfs.rocks \
    allowed_domains=ipfs.rocks \
    allow_subdomains=true \
    max_ttl=8928h
	# datastore
	vault write pki/roles/datastore \
		allow_ip_sans=true \
    allowed_domains=store.siderus.team \
    max_ttl=8928h \
		require_cn=false
.PHONY: pki_roles
