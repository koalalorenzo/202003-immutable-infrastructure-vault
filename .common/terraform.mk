VAULT_ADDR := https://vault.qm64.tech

.EXPORT_ALL_VARIABLES:

TF_OPTS ?=

# These phony targets are designed for automated process
_credentials:
# Checking if No Terraform credentials are available
ifeq (,$(wildcard ~/.terraformrc))
	@echo "Injecting credentials"
	@echo "credentials \"app.terraform.io\" { token = \"$(shell vault kv get -field=APP_TERRAFORM_IO secret/qm64/providers)\" }" > ~/.terraformrc
endif
.PHONY: _credentials

clean:
	-rm -rf .terraform
	-rm -rf ~/.terraformrc
.PHONY: clean

# Terrafom basics
_tf_init: _credentials
ifeq (,$(wildcard ./.terraform))
	terraform init -input=false ${TF_OPTS}
endif
.PHONY: _tf_init

validate: _tf_init
	terraform validate
.PHONY: validate

# Terraform targets
taint_%: _tf_init
	terraform taint ${TF_OPTS} $*
.PHONY: tf_taint

apply: _tf_init
	terraform apply -input=false -auto-approve ${TF_OPTS}
.PHONY: apply

plan: _tf_init
	terraform plan -input=false ${TF_OPTS}
.PHONY: plan

_destroy: _tf_init
	terraform destroy -input=false ${TF_OPTS}
.PHONY: destroy

.DEFAULT_GOAL :=
