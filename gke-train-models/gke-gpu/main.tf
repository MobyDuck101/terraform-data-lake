resource "google_service_account" "svacc-gke-train-0" {
  account_id   = "svacc-gke-train-0"
  display_name = "svacc-gke-train-0"
}

resource "google_project_iam_binding" "artifact-registry-reader-binding" {
  role    = "roles/artifactregistry.reader"
  project = var.project_id
  
  members = [
    "serviceAccount:svacc-gke-train-0@${var.project_id}.iam.gserviceaccount.com",
  ]
  depends_on = [google_service_account.svacc-gke-train-0]
}

resource "google_container_cluster" "model_training" {
  name     = var.cluster_name_gpu
  location = var.gke_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # remove_default_node_pool = true # comment out to allow node version to be set
  initial_node_count = 1
  # Delete the default node pool
  remove_default_node_pool = true

  project = var.project_id
  # node_locations = ["us-central1-a", "us-central1-c", "us-central1-f"]
  network    = var.network_name
  subnetwork = var.subnet_name_gpu

  ## Added stuff below to make private 

  # This setting will make the cluster private
  private_cluster_config {
    enable_private_nodes = "true"

    # To make testing easier, we keep the public endpoint available. In production, we highly recommend restricting access to only within the network boundary, requiring your users to use a bastion host or VPN.
    enable_private_endpoint = "false"

    master_ipv4_cidr_block = "173.16.0.0/28" ## Error if overlap with existing network
  }

  ip_allocation_policy {
    # cluster_ipv4_cidr_block  = "10.32.0.0/14"
    # services_ipv4_cidr_block = "10.0.0.0/20"
    # use_ip_aliases           = "false"
  }

  
  min_master_version = var.gke_min_master_version
  
}

resource "google_container_node_pool" "model_training_nodes" {
  name       = var.node_name_gpu
  location   = var.gke_location
  cluster    = google_container_cluster.model_training.name
  node_count = 1

  # GPU Specifcs are in this block
  node_config {
    preemptible  = false # cant be true for GPU
    machine_type = var.machine_type_gpu

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # This is created earlier and needs artofact registry access role granted. 
    service_account = google_service_account.svacc-gke-train-0.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    image_type = "COS_CONTAINERD"
    guest_accelerator {
      type  = var.accelerator_type_gpu #  "nvidia-tesla-t4"
      count = 1
    }
  }

}