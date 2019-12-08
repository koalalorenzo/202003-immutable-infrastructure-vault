# Hashicorp Vault setup

This repository contains [Hashicorp Vault](https://vaultproject.io)
configuration. This is not automated via Terraform due to the chicken-egg
nature. This set of makefiles are designed to be run with a non-initialized or
brand new Vault instance. Anyway, please proceede with caution as any change may
break automated part of our workflow.

## Tokens

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
