# Packer builds for Hashicorp Vault

This directory contains ansible playbooks and packer build setup designed to 
create a VM Image containing all the requirements to deploy Vault.

It will provide:

* Hashicorp Vault installed
* Uncomplicated Firewall 
* Mosh and SSH configuration changed to a more limiting one

This image will not contain any configuration, if not a basic "run for fun"
as it has been designed to be configured by [CloudInit](https://cloudinit.readthedocs.io)