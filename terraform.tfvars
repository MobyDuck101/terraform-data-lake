project_id = "nlp-dev-6aae"
#credentials_file_path = "../tf-sa-key/nlp-dev-6aae-fae5df70086f.json" // terraform
credentials_file_path       = "../tf-sa-key/nlp-dev-6aae-d3b64548129a.json" // new-terraform
region                      = "europe-west2"
main_zone                   = "europe-west2-a"
gcs_location                = "EUROPE-WEST2"
network_name                = "nle-netwrk-0"
subnet_name                 = "ingest-subnet-0"
cluster_name                = "ingest-cluster-0"
node_name                   = "ingest-node-0"
gke_location                = "europe-west2-a"
machine_type                = "e2-medium"
cluster_name_gpu            = "training-cluster-0"
subnet_name_gpu             = "training-subnet-0"
machine_type_gpu            = "n1-standard-4"
gke_min_master_version      = "1.24.7-gke.900" # Master version "1.22.12-gke.2300" is unsupported., badRequest
accelerator_type_gpu        = "nvidia-tesla-t4"
node_name_gpu               = "training-node-0"
registry_name               = "nle-repo"
gcs_bucket_name_landing     = "datalake-ingest-landing"
gcs_bucket_name_transcribed = "datalake-transcribed"
gcs_notif_topic_name        = "gcs-notif-topic"
## Not used atm due to TF Provider Error
gke_ingest_roles = [
  "roles/storage.admin",
  "roles/artifactregistry.reader",
]