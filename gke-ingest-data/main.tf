module "google_gke_gen" {
  source = "./gke-gen"

  project_id       = var.project_id
  region           = var.region
  gke_location     = var.gke_location
  network_name     = var.network_name
  cluster_name     = var.cluster_name
  subnet_name      = var.subnet_name
  machine_type     = var.machine_type
  node_name        = var.node_name
  gke_ingest_roles = var.gke_ingest_roles
  gke_min_master_version = var.gke_min_master_version
}

## Workaround for TFProvider Error when creating Multiple Member Roles
## This causes the second role creation to occur after a brief wait
## Current Error works if TF is rerun (again, after a wait...)
module "google_gke_gen_workaround" {
  source = "./workaround"

  project_id = var.project_id
  depends_on = [module.google_gke_gen]
}

module "google_eventarc_gcsnotif" {
  source = "./eventarc"

  project_id                  = var.project_id
  gcs_bucket_name_landing     = var.gcs_bucket_name_landing
  gcs_bucket_name_transcribed = var.gcs_bucket_name_transcribed
  gcs_notif_topic_name        = var.gcs_notif_topic_name
}