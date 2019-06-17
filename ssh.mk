ssh:
	-vault secrets enable ssh
	-vault write ssh/config/ca generate_signing_key=true
	cat ssh-role.json | vault write ssh/roles/admin -
.PHONY: ssh

ssh_client:
	vault write -field=signed_key ssh/sign/admin \
		public_key=@${HOME}/.ssh/id_rsa.pub > ${HOME}/.ssh/id_rsa-cert.pub
.PHONY: ssh_client
