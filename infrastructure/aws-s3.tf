resource "aws_s3_bucket" "vault" {
  bucket = "${random_pet.setup.id}-vault"
  acl    = "private"

  tags = {
    Name = "Vault Storage"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}