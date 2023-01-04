resource "google_container_cluster" "non-gpu-gke-cluster" {
  # This appears to be required to mitigate constraint constraints/compute.vmExternalIpAccess

  # Ensure Control Plane Not Acessible from Public internet
  # @DOCTAG: PRVT_CLSTR
  private_cluster_config {
    enable_private_nodes = "true"

    # To make testing easier, we keep the public endpoint available. In production, we highly recommend restricting access to only within the network boundary, requiring your users to use a bastion host or VPN.
    enable_private_endpoint = "false"

    master_ipv4_cidr_block = "172.16.0.0/28" ## Error if overlap with existing netwrok
  }
  # With a private cluster, it is highly recommended to restrict access to the cluster master
  # However, for testing purposes we will allow all inbound traffic.
  #     master_authorized_networks_config = [
  #       {
  #         cidr_blocks = [
  #           {
  #             cidr_block   = "0.0.0.0/0"
  #             display_name = "all-for-testing"
  #           },
  #         ]
  #       },
  #     ]    

  ## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#ip_allocation_policy
  ## Enables IP Aliasing, VPC-Native cluster
  ip_allocation_policy {
    # Values populated by T/F / GCP 
    # cluster_ipv4_cidr_block  = "10.32.0.0/14"
    # services_ipv4_cidr_block = "10.0.0.0/20"
    # use_ip_aliases           = "false"
  }
}

