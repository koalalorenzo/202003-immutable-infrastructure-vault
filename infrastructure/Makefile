TF_VAR_vault_ami ?=

# Get the credentials from Vault if not avaible!

CLOUDFLARE_API_TOKEN ?=  $(shell vault kv get -field=CLOUDFLARE_API_TOKEN secret/qm64/providers)
AMAZON_CREDENTIALS_FULL := $(shell vault read -format=json aws/creds/admin)
AWS_ACCESS_KEY_ID ?= $(shell echo '${AMAZON_CREDENTIALS_FULL}' | jq -r .data.access_key)
AWS_SECRET_ACCESS_KEY ?= $(shell echo '${AMAZON_CREDENTIALS_FULL}' | jq -r .data.secret_key)

.EXPORT_ALL_VARIABLES:

# I am importing some common terraform shortcut to avoid code repetition
# between 2 terraform setups.
include ../.common/terraform.mk