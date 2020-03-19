# Infrastructure terraform module
This directory contains the  terraform configuration to deploy the 
infrastructure required to maintain hashicorp vault on AWS with Cloudflare.

We are deploying Vault with some important features:

- Automatic IAM setup for Vault to access S3 with the right credentials
- This is an immutable infrastructure setup, so the configuration is injected 
  using [cloud-init](https://cloud-init.io/).
- There is a AWS EC2 Security Group that limits HTTPS access to Cloudflare 
  endpoints only.

Please read the source code's comment to know more.