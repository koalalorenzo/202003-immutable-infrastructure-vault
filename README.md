# Hashicorp Vault setup with AWS S3, EC2 and Immutable Infrastructure
Hey surfer! This repository has been updated on 2020/03/21, so some 
sections might be outdated if you are reading this from the future! 😉

This repository contains [Hashicorp Vault](https://vaultproject.io) 
configuration and immutable infrastructure setup. 

It is automated via Terraform and [GitLab](https://gitlab.com/qm64/vault) 
pipeline but it requires an initial setup that is manual. It uses some immutable 
infrastructure concept to deploy a AWS EC2 instance on Hashicorp Vault  
without manual operations. It can be easily modified to use other cloud vendors 
as the setup is cloud agnostic.

**Important Note**: most of this repository's is an example used in
this blog post: [Exploring Immutable Infrastructure on Vault](https://qm64.tech/posts/202003-immutable-infrastructure-vault/) for [Qm64](https://qm64.tech). 
this should be  considered as an example and it requires changes in order to 
be used! **READ THE README FILES** and please check the original 
[GitLab repository](https://gitlab.com/qm64/vault) for the latest updates.

## Before we start: About Credentials 
**This repo uses GNU Make a lot** to ensure that the env variables, conf and 
credentials are set correctly. _Why?_

Because if there is no Vault deployed yet, we need a manual way to deploy it!
After that GitLab CI/CD pipeline is capable to obtain temporary credentials from 
Vault itself. To achieve this we are using Make. Check the `Makefile`s to know
more. 😅

For the first deploy please make sure that your environment has the following 
variables set up:

- `CLOUDFLARE_API_TOKEN`: you can [generate a token here](https://dash.cloudflare.com/profile/api-tokens).
- `AWS_ACCESS_KEY_ID`: You can generate this from AWS Console
- `AWS_SECRET_ACCESS_KEY`: Idem

AWS credentials are required by both Terraform and Packer, while Cloudlfare's
are only used by Terraform to expose Vault.

Please install [Hashicorp Vault](https://vaultproject.io) on your computer/mac
as it will be the only way to interact with it.

**After Vault is configured** all you need is a `VAULT_TOKEN` and 
`VAULT_ADDR` variables configured correctly in your env 😜 Please consider
to use short-living and renewable tokens to reduce the attack surface.

## Packer Setup
Please read more in [the related README file](./packer/README.md) and 
the source code under `./packer`. Some comments might help you.

In order to keep secure and updated the Vault machine, every now and then
(usually monthly), the VM currently running gets recycled and replaced with a 
new one. To do this we use Packer, so that we can test and validate VM Images 
before upgrading to a new version.

Packer relies on Ansible to setup a basic firewall, SSH configurations and 
limits, packages upgrades as well as installing Hashicorp Vault and services.

To build the new image run:

```shell
make -C packer validate build
```

## Deploy Vault in EC2
Please read more in [the related README file](./infrastructure/README.md)

This setup is configured to support multiple environments (via [workspaces](https://www.terraform.io/docs/state/workspaces.html))
but it has designed around qm64 needs. In this example Vault is exposed to the 
whole public network (Behind Cloudflare's Proxy) to allow Gitlab to access it 
via an expiring token. This is a middle ground between safety and ease of 
access.

You can validate and plan the changes to AWS before applying:

```shell
make -C infrastructure plan
```

You can then apply the changes by running:

```shell
make -C infrastructure apply
```

For more details please check 
[infrastructure README file](./infrastructure/README.md) and the source code
under `./infrastructure`

## Post deploy Setup
Please read more in [the related README file](./configuration/README.md)
This is not part of the immutable infrastructure but about configuring Vault.

After vault has been deployed it [needs to be initialized](https://learn.hashicorp.com/vault/getting-started/deploy#initializing-the-vault). 
This is a manual operation: Set up `VAULT_ADDR` env variable to your domain and run:

```shell
# Please read the official documentation about this!
vault operator init
```

To run terraform plans on this repository you need a manual configuration.
Create a file called `configuration/terraform.tfvars` and inject the AWS 
credentials for Vault's user (hopefully not admin but capable of performing 
operations to  generate tokens with abilities to do stuff). This is used
to generate AWS expiring tokens with specific permissions. Check the
[official documentation](https://learn.hashicorp.com/vault/getting-started/dynamic-secrets) 
to learn more about this feature.

The content should look similar to this:

```
aws_access_key = "[...]"
aws_secret_key = "[...]"
```

Then validates that everything is correct by running: 

```shell
make -C configuration plan
```

## Shortcuts for Vault
This repository contains also some shortcuts to manage tokens, revoke them,
make the root token "expiring" etc etc. These are operations that are manual
and are written for ease into the main `Makefile`.

It is also possible to generate specific vault tokens to gain access to
specific part of the apps. All of them are time-based and short living and
some of them can be renewed.

### Recover Root token

The root token can be recovered in case of missing a renew of the current token.
Once the root token is recovered, it is required to create an expiring one and
revoke the original root token.

First we initiate the process:

```shh
make recover_root
```

Then we ask the people holding the vault unsealing keys to run
`vault operator generate-root` and to follow the instructions on screen.
This is not required if we are using a cloud provided KMS solution.

Once they have the output we can decrypt the token using
[keybase](https://keybase.io), and use it to create a new token.

```shell
export ENCRYPTED_TOKEN="INSERT_TOKEN_HERE"
vault login $(echo $ENCRYPTED_TOKEN | base64 -D | keybase pgp decrypt)
make token_admin
```

This will create a new orphan root token, with 7 days to live and that can be
renewed. It will also revoke the previous root token.
