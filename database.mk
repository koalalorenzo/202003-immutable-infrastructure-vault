DB_ADDRESS ?= 159.69.40.215
DB_PORT ?= 56737
DB_USERNAME ?= bubblegum
DB_PASSWORD ?= postgresql
DB_NAME ?= atlas-dev

psql:
	-vault secrets enable -path=postgres -max-lease-ttl=768h database
.PHONY: psql

psql_conf:
	vault write postgres/config/main \
		plugin_name=postgresql-psql-plugin \
		allowed_roles="*" \
		connection_url="postgresql://{{username}}:{{password}}@${DB_ADDRESS}:${DB_PORT}/${DB_NAME}" \
		username="${DB_USERNAME}" \
		password="${DB_PASSWORD}"
	$(MAKE) psql_roles
.PHONY: psql_conf

_psql_role_%:
	# Custom Postgres Roles for services/microservices and functions
	# note that the database must exist already and has to be set by ansible.
	vault write postgres/roles/$* \
		default_ttl="48h" max_ttl="744h" db_name=$* \
		creation_statements=" \
			CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
			GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
			GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\"; \
			GRANT ALL PRIVILEGES ON DATABASE \"$*\" TO \"{{name}}\"; \
		"


psql_roles: _psql_role_atlas-dev _psql_role_atlas-prod
	# Normal Admin to debug or check status
	vault write postgres/roles/admin \
		db_name=atlas-prod default_ttl="1h" max_ttl="3h"\
		creation_statements=" \
			CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
			GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
			GRANT ALL PRIVILEGES ON DATABASE \"atlas-prod\" TO \"{{name}}\"; \
			GRANT ALL PRIVILEGES ON DATABASE \"atlas-dev\" TO \"{{name}}\"; \
			ALTER ROLE \"{{name}}\" SUPERUSER CONNECTION LIMIT 3; \
		"

.PHONY: psql_roles

psql_rorate:
	# Rotate the root user password. This is useful to prevent root access and
	# force clients to use the temporary credentials provided by vault.
	vault write -f postgres/rotate-root/psql
.PHONY: psql_rorate

psql_creds_%:
	vault read postgres/creds/$*
.PHONY:
