variable "vault_ami" {
  description = "The Packer generated AMI to deploy"
}

variable "vault_domain" {
  description = "The domain to use"
  default = "vault.qm64.tech"
}


variable "vault_instance_type" {
  default = "t2.micro"  # Free elegible 
}
