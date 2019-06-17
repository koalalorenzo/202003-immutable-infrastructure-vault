VAULT_ADDR ?= https://vault.siderus.team
.EXPORT_ALL_VARIABLES:
POLICIES := $(shell ls -1 ./policies/ | sed 's/.hcl//g')
-include ./*.mk

policies:
	$(foreach var,$(POLICIES),vault policy write $(var) ./policies/$(var).hcl;)
.PHONY: policies

policy_%:
.PHONY: policy_%

kv:
	# Upgrade default kv secret/ to v2
	-vault kv enable-versioning secret/
.PHONY: kv

auth:
	-vault auth enable github
	# Github users should renew every 6h max life of 24h
	vault write auth/github/config organization=siderus max_ttl=12h ttl=3h
	vault write auth/github/map/teams/default value=developer
.PHONY: auth

recover_root:
	# Generating a new root token, please revoke it when you are done.
	# Later run `vault operator generate-root` for each sealing key"
	# The key will be base64 encoded and secured for keybase:koalalorenzo"
	-vault operator generate-root -init -pgp-key=keybase:koalalorenzo
	# Once done, please log in and use `make token_admin` to generate a proper
	# token. This will increase security level. Remember to revoke.
	#
	# Now you can run `vault operator generate-root`
.PHONY: recover_root

start_unseal_rekey:
	# Generate a new set of keys. This will invalidate the previous unseal keys
	vault operator rekey -init \
		-pgp-keys=keybase:koalalorenzo,keybase:koalalorenzo,keybase:koalalorenzo \
		-key-shares=3 -key-threshold=2 -backup
	# Now you can run `vault operator rekey`
	# The keys will be base64 encoded and secured for keybase:koalalorenzo"
.PHONY: start_rekey

seal:
	vault operator seal
.PHONY: seal

panic:
	vault operator rotate
	$(MAKE) psql_rorate trasit_rotate
	sleep 5
	$(MAKE) seal
.PHONY: panic

setup: kv auth policies transit ssh pki pki_roles
.PHONY: setup

ansible_prepare: letsencrypt_download update_internal_pki_ca token_ansible ssh_client
.PHONY: ansible_prepare

.ALL: setup