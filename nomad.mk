NOMAD_TOKEN ?=
NOMAD_ADDR ?= https://nomad.siderus.team:443

nomad:
	-vault secrets enable nomad
	vault write nomad/config/lease ttl=1h max_ttl=24h

	vault write nomad/config/access \
    address=${NOMAD_ADDR} \
    token=${NOMAD_TOKEN}

	$(MAKE) nomad_role
.PHONY: nomad

nomad_role:
	vault write auth/token/roles/nomad-cluster @nomad/nomad-cluster-role.json
.PHONY: nomad_role

nomad_token:
	# Note, creating a new Nomad token will force Terraform to re-create the nomad
	# clusters. ALL of them. Sleeping 10 seconds, so you can change your mind
	sleep 10
	# Create a Nomad Server token
	vault kv patch secret/infrastructure NOMAD_VAULT_TOKEN=$$( \
		vault token create -field=token -orphan -period=72h -renewable \
			-policy=nomad-server \
			-policy=secret-read \
			-policy=ssh-ca \
			-explicit-max-ttl=0 \
	)
.PHONY: nomad_token

nomad_acl_bootstrap:
	nomad acl bootstrap
.PHONY: nomad_acl_bootstrap

nomad_acl_policies:
	nomad acl policy apply deployer nomad/deployer-policy.hcl
	vault write nomad/role/readonly global=true type=client policies=readonly
	vault write nomad/role/deployer global=true type=client policies=readonly,deployer
	vault write nomad/role/admin type=management policies=
.PHONY: nomad_acl_policies

nomad_token_%:
	vault read nomad/creds/$*
