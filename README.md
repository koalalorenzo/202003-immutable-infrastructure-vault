# Hashicorp Vault setup with AWS S3, EC2 and Immutable Infrastructure

This repository contains [Hashicorp Vault](https://vaultproject.io) 
configuration and immutable infrastucture setup. 
This is partially automated via Terraform and GitLab pipeline due to the 
chicken-egg nature and security reasons. It uses some immutable 
infrastucture concept to deplouy a safer and updated Hashicorp Vault setup 
without manual operations.


**READ THE README FILE** as this is content intended as an example, 
but it is in use by [Qm64](https://qm64.tech). 

## Packer Setup
Please read more in [the related README file](./packer/README.md)

In order to keep secure and updated the Vault machine, every now and then
(monthly), the VM hosting vault gets recycled and replaced with a new one.
To acheive this we use Packer, so that we can test and validate VM Images 
before upgrading to a new version.

The packer builds uses Ansible to setup a basic firewall, SSH connection limits,
process upgrades as well as installing Hashicorp Vault and service.

To build it, please make sure that your AWS credentials are configured properly
using `aws configure`, then you can procede by running:

```shell
make -C packer validate build
```

## Deploy Vault in EC2
Please read more in [the related README file](./infrastructure/README.md)

Assuming that the `aws` cli has been configured you should be able to deploy the
AMI just created into a new EC2 instance. 

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
