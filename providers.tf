provider "vault" {
  version = "~> 2.4"
  address = "https://vault.qm64.tech"
}

# Cloudflare provider conf
provider "cloudflare" {
  version = "~> 2"
}

# provider "digitalocean" {
#   version = "~> 1.9"
# }

# provider "aws" {
#   version = "~> 2.41"
#   region  = "eu-west-1"
# }
