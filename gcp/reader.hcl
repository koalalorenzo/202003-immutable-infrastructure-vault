resource "//cloudresourcemanager.googleapis.com/projects/siderus-182902" {
	roles = ["roles/viewer"]
}

resource "buckets/vault-siderus-team" {
}

resource "buckets/tfstates" {
}