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
  provider = google-beta
  name     = var.cluster_name_gpu
  location = var.gke_location

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
  
  ## TFSec: google-gke-enable-network-policy - Medium - 
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/gke/enable-network-policy/
  ## https://kubernetes.io/docs/concepts/services-networking/network-policies/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_network_policy
  network_policy {
    enabled = true
  }

  project = var.project_id
  # node_locations = ["us-central1-a", "us-central1-c", "us-central1-f"]
  network    = var.network_name
  subnetwork = var.subnet_name_gpu

  ## TFSec: google-gke-enable-master-networks - High - Mitigates: Unrestricted network access to the master
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#master_authorized_networks_config 
  master_authorized_networks_config {
    cidr_blocks {
      # Opened up to allow demo/testing
      cidr_block   = "0.0.0.0/0"
      display_name = "all-for-testing"      
      ## This (below) makes the GKE Cluster unreacheable - use diff adresses. 
      #cidr_block = "10.10.128.0/24"
      #display_name = "internal"
   }
  }

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


  ## TFSec: google-gke-use-cluster-labels - Low - Mitigates: asset management limitations
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/gke/use-cluster-labels/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#resource_labels
  resource_labels = {
     "env" = "staging"
  }
}
#tfsec:ignore:google-gke-metadata-endpoints-disabled
resource "google_container_node_pool" "model_training_nodes" {
  name       = var.node_name_gpu
  location   = var.gke_location
  cluster    = google_container_cluster.model_training.name
  node_count = 1

  # GPU Specifcs are in this block
  node_config {
    
    ## TFSec: (CUSTOM) custom-custom-cus001 - High - Mitigates - lack of visibility re Workload Data Classification on GKE
    labels = {
      "DataClassification" = "LIMITED",
    }   

    preemptible  = false # cant be true for GPU
    machine_type = var.machine_type_gpu

    ## TFSec: node-metadata-security - High - Mitigates: makes it more difficult for a potential attacker to retrieve instance metadata.
    ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#node_metadata
    ## https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata#create-concealed
    ## @TODO: tfsec seems out of alignment with terrafrom
    workload_metadata_config {
        mode = "GCE_METADATA"
    }

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
  ## TFSec: google-gke-enable-auto-repair - Low - Mitigates: lack of automatic repair, so manual repair required.
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/gke/enable-auto-repair/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#auto_repair
  ## TFSec: google-gke-enable-auto-upgrade - Low - Mitigates: lack of automatic upgrade (of cluster master version), so manual upgrade required.
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/gke/enable-auto-upgrade/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#auto_upgrade
  management {
    auto_repair = true
    auto_upgrade = true
  }  
}