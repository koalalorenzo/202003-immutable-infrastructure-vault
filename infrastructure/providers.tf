# Cloudflare provider conf
provider "cloudflare" {
  version = "~> 2.3"
}

provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

resource "random_pet" "setup" {
  length = 2
  separator = "-" 
}
