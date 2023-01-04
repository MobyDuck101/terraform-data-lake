module "google_artifact_registry" {
  source = "./artifact-registry"

  project_id    = var.project_id
  region        = var.region
  registry_name = var.registry_name
}

module "google_networks" {
  source          = "./network"
  subnet_name_gpu = var.subnet_name_gpu
  project_id      = var.project_id
  region          = var.region
  network_name    = var.network_name
  subnet_name     = var.subnet_name
}

module "google_global_cloud_storage" {
  source = "./gcs"

  project_id                  = var.project_id
  region                      = var.region
  gcs_location                = var.gcs_location
  gcs_bucket_name_landing     = var.gcs_bucket_name_landing
  gcs_bucket_name_transcribed = var.gcs_bucket_name_transcribed

}