
# RabbitMQ configuration
path "rabbitmq/config/connection" {
  capabilities = ["create", "update", "read", "list"]
}

path "rabbitmq/creds/*"{
  capabilities = ["read", "list"]
}

# RabbitMQ service tokens
path "rabbitmq/roles/service" {
  capabilities = ["read"]
}
