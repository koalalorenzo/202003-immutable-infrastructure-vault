PGP_KEYS_INIT ?= keybase:koalalorenzo,keybase:koalalorenzo,keybase:kolalorenzo

################################################################################
# Shortcuts
################################################################################

recover_root:
	# Generating a new root token, please revoke it when you are done.
	# Later run `vault operator generate-root` for each sealing key"
	-vault operator generate-root -init -pgp-keys="${PGP_KEYS_INIT}"
	# Once done, please log in and use `make token_admin` to generate a proper
	# token. This will increase security level. Remember to revoke.
	# Secrets are encrypted with keybase's gpg 
.PHONY: recover_root

start_unseal_rekey:
	# Generate a new set of keys. This will invalidate the previous unseal keys
	vault operator rekey -init \
		-key-shares=3 -key-threshold=2 -backup \
		-pgp-keys="${PGP_KEYS_INIT}"
	# Now you can run `vault operator rekey`
	# The keys will be base64 encoded and secured for keybase:koalalorenzo"
.PHONY: start_rekey

seal:
	vault operator seal
.PHONY: seal

rotate:
	vault operator rotate
	-sleep 1
.PHONY: rotate 

panic: rotate seal
.PHONY: panic

token_pipeline:
	# Create a pipeline token capable of reading atlas secrets, that has 1w as life
	# time and can be renewed for a max of 4 weeks. It is orphan so that when
	# revoking the root token this will not be revoked too.
	#
	vault token create \
		-orphan -display-name="pipeline" \
	 	-policy=pipeline \
		-period=168h -explicit-max-ttl=4464h -ttl=168h
.PHONY: token_pipeline

token_admin:
	# Add admin token capable of running as root. This will help revoking root
	# token to increase security. Use this token with caution. It will expire
	# in 7 days and can be renewed for a max of 1 month. This token should
	# be used just for set up and monitoring during the next month.
	#
	vault token create -orphan -policy=root -period=168h \
		-explicit-max-ttl=744h -ttl=168h
	@echo "--- Press Enter when ready to revoke the root token ---"
	@read
	#
	# Since we have a new temporary root token, we can revoke the previous one
	# Please login with the new token once done.
	#
	vault token revoke -self
.PHONY: token_admin

token_quick_admin:
	# Add admin token capable of running as root.
	# This is a short living key that can't survive more than 3h (default 5m).
	# Use this for things like browser or quick tests.
	vault token create -policy=root -period=15m -explicit-max-ttl=3h -ttl=5m
.PHONY: token_quick_admin

ssh_client:
	# Gain access to SSH by signing your own SSH id_rsa key.
	vault write -field=signed_key ssh/sign/admin public_key=@${HOME}/.ssh/id_rsa.pub > ${HOME}/.ssh/id_rsa-cert.pub
.PHONY: ssh_client
