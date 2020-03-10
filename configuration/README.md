# Vault Setup via Terraform

This directory contains a basic/example Vault setup done via terraform.
By providing the right AWS credentials, this will create:

* A KV v2 Secret engine (the one with versioning)
* PKI for certificates
* AWS secret engine for temporary AWS credentials
* Some policies for Packer and GitLab pipeline
* SSH for limited temporary access to VMs if needed
* A transit vault module for end-to-end encryption on the fly.

All of those are currently in use by Qm64 as part of examples.