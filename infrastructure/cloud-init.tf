
###
# Cloud Init setup
# This allows the instance to access the s3 bucket
###

# Prepare vault configuration file with teh AWS S3 bucket details
data "template_file" "vault_conf" {
  template = "${file("${path.module}/templates/vault-config.hcl.tpl")}"
  vars = {
    vault_s3_bucket_name   = aws_s3_bucket.vault.id
    vault_s3_bucket_region = aws_s3_bucket.vault.region
    qm64_vault_domain = var.vault_domain
  }
}

# Inject Vault configuration file into the cloud-init file. :-)
data "template_file" "cloud_init" {
  template = "${file("${path.module}/templates/cloud-init.tpl")}"
  vars = {
    vault_configuration_b64 = base64encode(data.template_file.vault_conf.rendered)
    qm64_vault_domain = var.vault_domain
  }
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_init.rendered}"
  }
}