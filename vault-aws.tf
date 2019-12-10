variable "aws_access_key" {}
variable "aws_secret_key" {}


resource "vault_aws_secret_backend" "aws" {
  access_key                = var.aws_access_key
  secret_key                = var.aws_secret_key
  default_lease_ttl_seconds = 5 * 60  # 5 min
  max_lease_ttl_seconds     = 60 * 60 # 1h
}

resource "vault_aws_secret_backend_role" "role_admin" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "admin"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
EOT
}

resource "vault_aws_secret_backend_role" "role_reader" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "reader"
  credential_type = "iam_user"
  policy_arns     = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
}

resource "vault_aws_secret_backend_role" "s3" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "s3"
  credential_type = "iam_user"
  policy_arns     = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}
