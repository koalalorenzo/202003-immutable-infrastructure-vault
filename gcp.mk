GOOGLE_CLOUD_PROJECT ?= siderus-182902
VAULT_SA_EMAIL ?= vault-sa@siderus-182902.iam.gserviceaccount.com
.EXPORT_ALL_VARIABLES:

gcp:
	-vault secrets enable -max-lease-ttl=12h -default-lease-ttl=1h gcp
	# Set accounts to live max for 12h
	-vault write gcp/config max_ttl=6h ttl=30m credentials=@gcp.vault.secret.json
	# Load in GCP the right configuration
	gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
    --member="serviceAccount:${VAULT_SA_EMAIL}" \
    --role="roles/iam.serviceAccountAdmin"
	gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
    --member="serviceAccount:${VAULT_SA_EMAIL}" \
    --role="roles/iam.serviceAccountKeyAdmin"
	-gcloud iam roles create Vault \
    --quiet \
    --project ${GOOGLE_CLOUD_PROJECT} \
    --file gcp/gcp-vault-admin.yaml
	gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
    --member="serviceAccount:${VAULT_SA_EMAIL}" \
    --role="projects/${GOOGLE_CLOUD_PROJECT}/roles/Vault"
.PHONY: gcp

gcp_roleset:
	# Setup rolesets for GCP
	-vault write gcp/roleset/reader \
			project="${GOOGLE_CLOUD_PROJECT}" \
			secret_type="service_account_key"  \
			bindings=@gcp/reader.hcl
	-vault write gcp/roleset/storage \
			project="${GOOGLE_CLOUD_PROJECT}" \
			secret_type="service_account_key"  \
			bindings=@gcp/storage.hcl
	-vault write gcp/roleset/admin \
			project="${GOOGLE_CLOUD_PROJECT}" \
			secret_type="service_account_key"  \
			bindings=@gcp/admin.hcl
.PHONY: gcp_roleset
