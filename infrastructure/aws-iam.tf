###
# Vault IAM Policy.
# This allows the instance to access the s3 bucket
###

resource "aws_iam_instance_profile" "vault" {
  name = "${random_pet.setup.id}-vault-s3-storage"
  role = aws_iam_role.vault.name
}
resource "aws_iam_role" "vault" {
  name               = "${random_pet.setup.id}-vault-s3-storage"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.vault_instance_role.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "vault_s3" {
  name   = "${random_pet.setup.id}-vault-s3-storage"
  role   = aws_iam_role.vault.id
  policy = data.aws_iam_policy_document.vault_s3.json

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_iam_policy_document" "vault_s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.vault.arn}",
      "${aws_s3_bucket.vault.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "vault_instance_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}