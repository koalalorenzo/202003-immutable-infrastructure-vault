TF_VAR_vault_ami ?= ami-01148191aa160ed58

CLOUDFLARE_API_TOKEN ?=  $(shell vault kv get -field=CLOUDFLARE_API_TOKEN secret/qm64/providers)

.EXPORT_ALL_VARIABLES:

include ../.common/terraform.mk