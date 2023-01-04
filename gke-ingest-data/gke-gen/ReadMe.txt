#
# GCP Console monitor - https://console.cloud.google.com/kubernetes/clusters/details/europe-west2-a/private-cluster-0/details?authuser=2&project=nlp-dev-6aae 
# GCP Console logs - https://console.cloud.google.com/compute/instancesDetail/zones/europe-west2-a/instances/gke-private-cluster-0-default-pool-f8e304f2-hg3p/console?port=1&authuser=2&project=nlp-dev-6aae  
#

/*
Error: Request `Set IAM Binding for role "roles/artifactregistry.reader" on "project \"nlp-dev-6aae\""` 
returned error: Error retrieving IAM policy for project "nlp-dev-6aae": googleapi: 
Error 403: Cloud Resource Manager API has not been used in project 301918148666 
before or it is disabled. Enable it by visiting 
https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=301918148666 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
*/

## Multi-role Binding - https://stackoverflow.com/questions/61661116/want-to-assign-multiple-google-cloud-iam-roles-to-a-service-account-via-terrafor 
## switch to generated\google\nlp-dev-6aae\iam\europe-west2\project_iam_member.tf for this account. instead of bindings whch  are useless for multi-role.
#resource "google_project_iam_binding" "artifact-registry-reader-binding" {
#  role               = "roles/artifactregistry.reader"
#  project            = var.project_id 
  /*
  Error: Request `Set IAM Binding for role "roles/artifactregistry.reader" on 
  "project \"nlp-dev-6aae\""` returned error: 
  Error applying IAM policy for project "nlp-dev-6aae": 
  Error setting IAM policy for project "nlp-dev-6aae": googleapi: Error 400: Service account gke_svc_acct_ingest_node_pool_0@nlp-dev-6aae.iam.gserviceaccount.com does not exist., badRequest
  */
#  members = [
#    "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com",
#  ]
#  depends_on = [google_service_account.svacc-gke-ingest-0]
#}
## Looks like 2nd binding has ovewritten 1st!
#resource "google_project_iam_binding" "storage-object-admin-binding" {
#  role               = "roles/storage.objectAdmin"
#  project            = var.project_id 
#  /*
#  {Permits contaied app to read/write to GCS}
#  */
#  members = [
#    "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com",
#  ]
#  depends_on = [google_service_account.svacc-gke-ingest-0]
#}
#resource "google_project_iam_member" "gke_sa_iam" {
#  for_each = toset(var.gke_ingest_roles)
#
#  project = var.project_id
#  role    = each.value
#  member  = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"#
#
#  depends_on = [
#    google_service_account.svacc-gke-ingest-0,
#  ]
#}

#resource "google_project_iam_member" "gke-2-artifact-registry-access" {
#  #service_account_id = google_service_account.svacc-gke-ingest-0.name - bad example
#  member  = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
#  project = var.project_id
#  role    = "roles/artifactregistry.reader"
#  depends_on = [google_service_account.svacc-gke-ingest-0] # disallowed in tf plan
#}


# Workaround for Health check Error - https://github.com/hashicorp/terraform-provider-google/issues/6842 
/*
The cluster creation hangs at the "Health Checks" portion and it looks as if the default node pool never gets created. It hangs for about 20 minutes before finally failing with the following message:
*/
#   node_version    = "1.22.12-gke.2300" # Taken from Sucessfully created GKE From Terraformer # if this works it should be a variable