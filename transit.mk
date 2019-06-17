
transit:
	-vault secrets enable transit
.PHONY: transit

trasit_keys:
	vault write -f transit/keys/meta.siderus.io
	vault write -f transit/keys/infrastructure
.PHONY: trasit_keys

trasit_rotate:
	vault write -f transit/keys/meta.siderus.io/rotate
	vault write -f transit/keys/infrastructure/rotate
.PHONY: trasit_rotate