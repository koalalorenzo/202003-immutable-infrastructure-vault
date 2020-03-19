# Cloudflare provider conf
provider "cloudflare" {
  version = "~> 2.3"
}

provider "aws" {
  version = "~> 2.50"
  region  = "eu-west-1"
}

# We are generating a random name for our resources, this is used to 
# ensure that we are not reusing some resources across multiple environments
# (ex: Production S3 bucket will differ from the development one). 
# Consider this as a vital feature for immutable infrastructure as we should
# not be able to differentiate machines or resources! ;-)
resource "random_pet" "setup" {
  length = 2
  separator = "-" 
}
