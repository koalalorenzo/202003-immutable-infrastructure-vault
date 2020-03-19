# Hashicorp Vault setup with AWS S3, EC2 and Immutable Infrastructure

This repository contains [Hashicorp Vault](https://vaultproject.io) 
configuration and immutable infrastucture setup. 
This is partially automated via Terraform and GitLab pipeline due to the 
chicken-egg nature and security reasons. It uses some immutable 
infrastucture concept to deplouy a safer and updated Hashicorp Vault setup 
without manual operations.

Note that part of this repository's description is showcased in
this blog post: [Exploring Immutalbe Infrastructure on Vault](https://qm64.tech/posts/202003-immutable-infrastructure-vault/). **This is an example** and it requires 
changes in order to be used!

**READ THE README FILE** as this is content is both an example and it is live 
and used by [Qm64](https://qm64.tech) project's. Please check 
[GitLab repository](https://gitlab.com/qm64/vault) for the latest updates.

## Before we start: About Credentials 
**This repo uses Make** to ensure that the env variables and credentials are set 
correctly. Why?

Because if there is no Vault deployed yet, we need a manual way to deploy it!
After that Gitlab CI/CD pipeline is capable to obtain the credentials from 
Vautl itself. To acheive this we are using Make. Check the `Makefiles` to know
more. 😅

For the first deploy please make sure that your environment has the following 
variables set up:

- `CLOUDFLARE_API_TOKEN`: you can [generate a token here](https://dash.cloudflare.com/profile/api-tokens).
- `AWS_ACCESS_KEY_ID`: You can generate this from AWS Console
- `AWS_SECRET_ACCESS_KEY`

AWS credentials are required by both Terraform and Packer, while Cloudlfare
is only used by Terraform to expose Vault.

**After Vault is configured** all you need is to have `VAULT_TOKEN` and 
`VAULT_ADDR` configured correctly in your env 😜

## Packer Setup
Please read more in [the related README file](./packer/README.md)

In order to keep secure and updated the Vault machine, every now and then
(usually monthly), the VM hosting vault gets recycled and replaced with a new 
one. To acheive this we use Packer, so that we can test and validate VM Images 
before upgrading to a new version.

The packer builds uses Ansible to setup a basic firewall, SSH connection limits,
process upgrades as well as installing Hashicorp Vault and service.

To build the new image run:

```shell
make -C packer validate build
```

## Deploy Vault in EC2
Please read more in [the related README file](./infrastructure/README.md)

You can validate and plan the changes to AWS before applying:

```shell
make -C infrastructure plan
```

You can then apply the changes by running:

```shell
make -C infrastructure apply
```

For a full understanding and more details please check 
[infrastructure README file](./infrastructure/README.md)

## Post deploy Setup
Please read more in [the related README file](./configuration/README.md)

To run terraform plans on this repository you need a manual configuration.
Create a file called `configuration/terraform.tfvars` and inject the AWS 
credentials for  Vault's user (hopefully not admin but capable of performing 
operations to  generate tokens with abilities to do stuff).

The content should look similar to this:

```
aws_access_key = "[...]"
aws_secret_key = "[...]"
```

Then validates that everything is correct by running: 

```
make -C configuration plan
```


## Shortcuts for Vault
This repository contains also some shortcuts to manage tokens, revoke them,
make the root token "expiring" etc etc. These are operations that are manual
and 

It is also possible to generate specific vault tokens to gain access to
specific part of the apps. All of them are time-based and short living and
some of them can be renewed.

### Recover Root token

The root token can be recovered in case of missing a renew of the current token.
Once the root token is recovered, it is required to create an expiring one and
revoke the original root token. For example

First we initiate the process:

```shh
make recover_root
```

Then we ask the people holding the vault unsealink keys to run
`vault operator generate-root` and to follow the instructions on screen.

Once they have the output we can decrypt the token using
[keybase](https://keybase.io), and use it to create a new token.

```shell
export ENCRYPTED_TOKEN="INSERT_TOKEN_HERE"
vault login $(echo $ENCRYPTED_TOKEN | base64 -D | keybase pgp decrypt)
make token_admin
```

This will create a new orphan root token, with 7 days to live and that can be
renewed. It will also revoke the previous root token.
