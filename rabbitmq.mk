rabbitmq:
	-vault secrets enable -max-lease-ttl=768h rabbitmq
.PHONY: rabbitmq

rabbitmq_config:
	# Often this is not necessary, as the configuration is defined by the VM
	# Use this as a reference for future command in case a manual setup is needed.
	# Usually Ansible sets up everything correctly.
	vault write rabbitmq/config/lease ttl=48h max_ttl=768h
	vault write rabbitmq/config/connection
		connection_uri="http://${PUBSUB_ADDRESS}:${PUBSUB_PORT}"
		username="${PUBSUB_USERNAME}"
		password="${PUBSUB_PASSWORD}"
.PHONY: rabbitmq_config

rabbitmq_roles:
	vault write rabbitmq/roles/admin \
		vhosts='{"/":{"write": ".*", "read": ".*", "configure": ".*"},"dev":{"write": ".*", "read": ".*", "configure": ".*"},"prod":{"write": ".*", "read": ".*", "configure": ".*"}}' \
		tags='administrator'
	vault write rabbitmq/roles/reader \
		vhosts='{"/":{"read": ".*"}, "dev":{"read": ".*"}, "prod":{"read": ".*"}}' \
		tags='monitoring'
	vault write rabbitmq/roles/atlas-dev \
		vhosts='{"dev":{"write": ".*", "read": ".*", "configure": ".*"}}'
	vault write rabbitmq/roles/atlas-prod \
		vhosts='{"prod":{"write": ".*", "read": ".*", "configure": ".*"}}'
.PHONY: rabbitmq_roles

rabbitmq_creds_%:
	vault read rabbitmq/creds/$*
