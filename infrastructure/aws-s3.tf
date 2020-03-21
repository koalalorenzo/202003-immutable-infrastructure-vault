# Cereate a S3 bucket that will be used by vault.
# Note that the name is random so that we can test it on multiple environments
# for multiple versions. Note also the prevent destroy to reduce the risk of
# data loss in case we accidentally run `terraform destroy` ;-)
resource "aws_s3_bucket" "vault" {
  bucket = "${random_pet.setup.id}-vault"
  acl    = "private"

  tags = {
    Name = "Vault Storage"
  }

  lifecycle {
    prevent_destroy = true
  }
}