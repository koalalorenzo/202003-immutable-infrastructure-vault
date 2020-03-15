TF_VAR_vault_ami ?= ami-01148191aa160ed58

CLOUDFLARE_API_TOKEN ?=  $(shell vault kv get -field=CLOUDFLARE_API_TOKEN secret/qm64/providers)

# Get the credentials from Vault if not avaible!
AMAZON_CREDENTIALS_FULL := $(shell vault read -format=json aws/creds/admin)
AWS_ACCESS_KEY_ID ?= $(shell echo '${AMAZON_CREDENTIALS_FULL}' | jq -r .data.access_key)
AWS_SECRET_ACCESS_KEY ?= $(shell echo '${AMAZON_CREDENTIALS_FULL}' | jq -r .data.secret_key)
.EXPORT_ALL_VARIABLES:

include ../.common/terraform.mk