resource "//cloudresourcemanager.googleapis.com/projects/siderus-182902" {
	roles = ["roles/storage.objectAdmin", "roles/storage.admin"]
}

resource "buckets/vault-siderus-team" {
}

resource "buckets/tfstates" {
}