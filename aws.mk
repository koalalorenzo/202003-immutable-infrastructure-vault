
AWS_REGION ?= eu-west-1

AWS_ACCESSKEY ?=
AWS_SECRETKEY ?=

aws:
	-vault secrets enable -max-lease-ttl=12h -default-lease-ttl=1h -path=aws aws
	vault write aws/config/lease lease=30m lease_max=12h
	vault write aws/config/root \
		access_key=${AWS_ACCESSKEY} \
		secret_key=${AWS_SECRETKEY} \
		region=${AWS_REGION}
.PHONY: aws

aws_policies:
	vault write aws/roles/admin \
		credential_type=iam_user \
		policy_document=@aws/admin_policy.json

	vault write aws/roles/terraform \
		credential_type=iam_user \
		policy_document=@aws/terraform_policy.json

	vault write aws/roles/packer \
		credential_type=iam_user \
		policy_document=@aws/admin_policy.json

	vault write aws/roles/reader \
		credential_type=iam_user \
		policy_arns="arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"

	vault write aws/roles/s3 \
		credential_type=iam_user \
		policy_arns="arn:aws:iam::aws:policy/AmazonS3FullAccess"

	vault write aws/roles/lambda \
		credential_type=iam_user \
		policy_arns="arn:aws:iam::aws:policy/AWSLambdaFullAccess"

	vault write aws/roles/atlas \
		credential_type=iam_user \
		policy_document=@aws/atlas_policy.json

.PHONY: aws_policies