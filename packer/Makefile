VAULT_VERSION :=1.3.2

.EXPORT_ALL_VARIABLES:

BUILD_PLATFORM ?= amazon-ebs
BUILD_OPTS ?=-only=${BUILD_PLATFORM}
VALID_OPTS ?=-only=${BUILD_PLATFORM}


validate:
	packer validate ${VALID_OPTS} build.json
.PHONY: validate

build: 
	packer build ${BUILD_OPTS} build.json
.PHONY: build