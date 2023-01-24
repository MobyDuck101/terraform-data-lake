## PlayPen-PreReqs: Pls Comment out the terraform block below. 
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      # version = "= 4.21.0" # used on BJSS to test for backward compatibility
      version = "~> 4.36.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

provider "google-beta" {
  credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}
#
## Create an array of GCS Bucket Names
## This is a combination/merge of
## * Project (Single Value from Var)
## * Use Case (Single Value from Var)
## * Transition State (Project-UseCase-Transition-1-to-N)
### Do all this in locals file and output results 

# Core (Standalone) Components
# Artifact Registry
# Cloud Storage
# Virtual Private Cloud
module "google_core" {
  source = "./core"

  project_id = var.project_id
  region     = var.region

  registry_name = var.registry_name

  subnet_name_gpu = var.subnet_name_gpu
  network_name    = var.network_name
  subnet_name     = var.subnet_name

  gcs_location                = var.gcs_location
  gcs_bucket_name_landing     = local.bucket_name_landing
  gcs_bucket_name_transcribed = local.bucket_name_transcribed

}
/*
module "google_gke_ingest" {
  source = "./gke-ingest-data"

  project_id       = var.project_id
  region           = var.region
  gke_location     = var.gke_location
  network_name     = var.network_name
  cluster_name     = var.cluster_name
  subnet_name      = var.subnet_name
  machine_type     = var.machine_type
  node_name        = var.node_name
  gke_min_master_version = var.gke_min_master_version
  gke_ingest_roles = var.gke_ingest_roles
  gcs_bucket_name_landing     = local.bucket_name_landing
  gcs_bucket_name_transcribed = local.bucket_name_transcribed
  gcs_notif_topic_name        = var.gcs_notif_topic_name
  depends_on       = [module.google_core]
}
*/

module "google_gke_train" {
  source = "./gke-train-models"

  project_id           = var.project_id
  region               = var.region
  gke_location         = var.gke_location
  network_name         = var.network_name
  cluster_name_gpu     = var.cluster_name_gpu
  subnet_name_gpu      = var.subnet_name_gpu
  machine_type_gpu     = var.machine_type_gpu
  accelerator_type_gpu = var.accelerator_type_gpu
  node_name_gpu        = var.node_name_gpu
  gke_min_master_version = var.gke_min_master_version
  depends_on           = [module.google_core]
}