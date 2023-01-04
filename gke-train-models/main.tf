module "google_gke_gpu" {
  source = "./gke-gpu"

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
}