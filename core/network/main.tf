resource "google_compute_network" "vpc_network" {
  name                            = var.network_name
  auto_create_subnetworks         = "false"
  ## PlayPen-PreReqs: please comment out line below so that GCP Providder 4.21 works 
  enable_ula_internal_ipv6        = "false"
  mtu                             = "1460"
  routing_mode                    = "REGIONAL"
  project                         = var.project_id
  delete_default_routes_on_create = "true"
}
resource "google_compute_subnetwork" "vpc_network_subnet" {
  ip_cidr_range              = "10.2.204.0/22"
  name                       = var.subnet_name
  network                    = var.network_name
  private_ip_google_access   = "true"
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  project                    = var.project_id
  purpose                    = "PRIVATE"
  region                     = var.region

  stack_type = "IPV4_ONLY"

  depends_on = [google_compute_network.vpc_network]
  ## TFSec: google-compute-enable-vpc-flow-logs- Low - Mitigates: Limited Observability wrt Audit events
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/compute/enable-vpc-flow-logs/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#enable_flow_logs
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }  
}

resource "google_compute_subnetwork" "vpc_network_subnet_gpu" {
  ip_cidr_range              = "10.3.204.0/22"
  name                       = var.subnet_name_gpu
  network                    = var.network_name
  private_ip_google_access   = "true"
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  project                    = var.project_id
  purpose                    = "PRIVATE"
  region                     = var.region

  stack_type = "IPV4_ONLY"

  depends_on = [google_compute_network.vpc_network]
  ## TFSec: google-compute-enable-vpc-flow-logs- Low - Mitigates: Limited Observability wrt Audit events
  ## https://aquasecurity.github.io/tfsec/v1.22.1/checks/google/compute/enable-vpc-flow-logs/
  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#enable_flow_logs  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }  
}

#
# Fix for this error encountered during health checks - [ 1020.660187] configure.sh[972]: == Failed to download https://storage.googleapis.com/gke-release/npd-custom-plugins/v1.0.4/npd-custom-plugins-v1.0.4.tar.gz. Retrying. == 
# Counter-Intuitive given this is supposed to be a PRIVATE cluster
#
resource "google_compute_route" "default-route-inet" {
  description = "Default route to the Internet."
  dest_range  = "0.0.0.0/0"
  name        = "default-route-inet"
  network     = var.network_name
  #next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/nlp-dev-6aae/global/gateways/default-internet-gateway"
  next_hop_gateway = "default-internet-gateway"
  priority         = "1000"
  project          = var.project_id
  depends_on       = [google_compute_network.vpc_network]
}