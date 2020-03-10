
# Start an AWS instance with the cloud-init config as user data
resource "aws_instance" "vault" {
  depends_on = [
    aws_s3_bucket.vault, aws_iam_instance_profile.vault, aws_iam_role_policy.vault_s3
  ]
  ami           = var.vault_ami
  instance_type = var.vault_instance_type

  iam_instance_profile = aws_iam_role.vault.name

  security_groups = [aws_security_group.cloudflare-http.name, aws_security_group.allow-exit.name, aws_security_group.ssh.name]
  root_block_device {
    volume_size = "8"
  }

  user_data_base64 = data.template_cloudinit_config.config.rendered

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${random_pet.setup.id}-vault"
  }
}
