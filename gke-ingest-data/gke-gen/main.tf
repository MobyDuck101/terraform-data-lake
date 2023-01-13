resource "google_service_account" "svacc-gke-ingest-0" {
  account_id   = "svacc-gke-ingest-0"
  display_name = "svacc-gke-ingest-0"
}

resource "google_project_iam_member" "gke_sa_iam_1" {
  member     = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
  project    = var.project_id
  role       = "roles/storage.objectAdmin"
  depends_on = [google_service_account.svacc-gke-ingest-0, ]
}

resource "google_container_cluster" "non-gpu-gke-cluster" {
  name     = var.cluster_name
  location = var.gke_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # remove_default_node_pool = true # comment out to allow node version to be set
  initial_node_count = 1
  # Delete the default node pool
  remove_default_node_pool = true

  project    = var.project_id
  network    = var.network_name
  subnetwork = var.subnet_name

  min_master_version = var.gke_min_master_version

  node_config {

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # This is created earlier and needs artifact registry access role granted. 
    service_account = google_service_account.svacc-gke-ingest-0.email
  }

}

resource "google_container_node_pool" "non-gpu-node-pool" {
  name       = var.node_name
  location   = var.gke_location
  cluster    = google_container_cluster.non-gpu-gke-cluster.name
  node_count = 1

  node_config {
    labels = {
      "DataClassification" = "LIMITED",
    }

    preemptible  = true
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # This is created earlier and needs artifact registry access role granted. 
    service_account = google_service_account.svacc-gke-ingest-0.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    image_type = "COS_CONTAINERD"
  }
}