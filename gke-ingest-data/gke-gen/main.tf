resource "google_service_account" "svacc-gke-ingest-0" {
  account_id   = "svacc-gke-ingest-0"
  display_name = "svacc-gke-ingest-0"
}
## TFsec - google-iam-no-privileged-service-accounts - High - Least Privilege
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
## https://cloud.google.com/iam/docs/understanding-roles 
## Replaces storage.objectAdmin
resource "google_project_iam_member" "gke_sa_iam_1" {
  member     = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
  project    = var.project_id
  role       = "roles/storage.objectCreator"
  depends_on = [google_service_account.svacc-gke-ingest-0, ]
}
resource "google_project_iam_member" "gke_sa_iam_2" {
  member     = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
  project    = var.project_id
  role       = "roles/storage.objectViewer"
  depends_on = [google_project_iam_member.gke_sa_iam_1, ]
}


resource "google_container_cluster" "non-gpu-gke-cluster" {
  ## TFSec: metadata-endpoints-disabled - High - Mitigates: makes it more difficult for a potential attacker to retrieve instance metadata.
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#metadata
  ## https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#protect_node_metadata_default_for_112
  ## @TODO This example does not pass terraform validate
  #metadata {
  #   disable-legacy-endpoints = true
  #}  

  provider = google-beta
  name     = var.cluster_name
  location = var.gke_location  # This IS required to mitigate constraint constraints/compute.vmExternalIpAccess

  # Ensure Control Plane Not Acessible from Public internet
  # @DOCTAG: PRVT_CLSTR
  private_cluster_config {
    enable_private_nodes = "true"

    # To make testing easier, we keep the public endpoint available. In production, we highly recommend restricting access to only within the network boundary, requiring your users to use a bastion host or VPN.
    enable_private_endpoint = "false"

    master_ipv4_cidr_block = "172.16.0.0/28" ## Error if overlap with existing netwrok
  }
  ## Below required with Private Cluster
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#ip_allocation_policy
  ## Enables IP Aliasing, VPC-Native cluster
  ip_allocation_policy {
    # Values populated by T/F / GCP 
    # cluster_ipv4_cidr_block  = "10.32.0.0/14"
    # services_ipv4_cidr_block = "10.0.0.0/20"
    # use_ip_aliases           = "false"
  }



  ## TFSec: google-gke-enforce-pod-security-policy - High - Mitigates: Pods could be operating with more permissions than required to be effective
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#pod_security_policy_config 
  ## Uses google-beta provider
  pod_security_policy_config {
      enabled = "true"
  }  

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # remove_default_node_pool = true # comment out to allow node version to be set
  initial_node_count = 1
  # Delete the default node pool
  remove_default_node_pool = true
  
  ## TFSec: google-gke-enable-master-networks - High - Mitigates: Unrestricted network access to the master
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#master_authorized_networks_config 
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.10.128.0/24"
      display_name = "internal"
   }
  } 

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
    ## TFSec: node-metadata-security - High - Mitigates: makes it more difficult for a potential attacker to retrieve instance metadata.
    ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#node_metadata
    ## https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata#create-concealed
    ## @TODO: tfsec seems out of alignment with terrafrom
    workload_metadata_config {
        mode = "GCE_METADATA"
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