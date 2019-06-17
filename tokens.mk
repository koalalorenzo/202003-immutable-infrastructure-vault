
token_pipeline:
	# Create a pipeline token capable of reading atlas secrets, that has 1w as life
	# time and can be renewed for a max of 4 weeks. It is orphan so that when
	# revokign the root token this will not be revoked too.
	#
	vault token create \
		-orphan -display-name="pipeline" \
		-policy=panic \
	 	-policy=pki-issue-cert \
		-policy=aws -policy=gcp \
		-policy=terraform -policy=packer -policy=nomad \
		-policy=secret-write -policy=secret-read \
		-policy=ssh-ca -policy=ssh \
		-policy=gateway \
		-period=168h -explicit-max-ttl=4464h -ttl=168h
.PHONY: token_pipeline

token_admin:
	# Add admin token capable of running as root. This will help revoking root
	# token to increase security. Use this token with caution. It will expire
	# in 72h (3 days) and can be renewed for a max of 1 month. This token should
	# be used just for set up and monitoring during the next month.
	#
	vault token create -orphan -policy=root -period=72h \
		-explicit-max-ttl=744h -ttl=72h
	#
	# Since we have a new temporary root token, we can revoke the previous one
	# Please login with the new token once done.
	#
	vault token revoke -self
.PHONY: token_admin

token_quick_admin:
	# Add admin token capable of running as root.
	# This is a short living key that can't survive more than 3h (default 5m).
	# Use this for things like browser or quick tests.
	vault token create -policy=root -period=15m -explicit-max-ttl=3h -ttl=5m
.PHONY: token_quick_admin
