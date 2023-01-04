variable "project_id" {
  type        = string
  description = "The ID of the project to create resources in"
}

variable "region" {
  type        = string
  description = "The region to use"
}

variable "main_zone" {
  type        = string
  description = "The zone to use as primary"
}

variable "credentials_file_path" {
  type        = string
  description = "The credentials JSON file used to authenticate with GCP"
}

variable "gcs_location" {
  type        = string
  description = "Global Cloud Storage Bucket Location"
}

variable "gke_location" {
  type        = string
  description = "GKE Location: different format to GCS"
}

variable "network_name" {
  type        = string
  description = "Name of VPC Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of VPC Subnet"
}
variable "cluster_name" {
  type        = string
  description = "Name of GKE Cluster"
}

variable "machine_type" {
  type        = string
  description = "GKE Cluster Node Machine Type"
}

variable "cluster_name_gpu" {
  type        = string
  description = "The cluster to use"
}

variable "subnet_name_gpu" {
  type        = string
  description = "The subnet to use"
}

variable "machine_type_gpu" {
  type        = string
  description = "GKE Cluster Node Machine Type"
}

variable "accelerator_type_gpu" {
  type        = string
  description = "GPU Acclerator Type"
}

variable "node_name_gpu" {
  type        = string
  description = "GPU Node Name"
}

variable "node_name" {
  type        = string
  description = "Node Name"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "example-private-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.5.0.0/28"
}

# For the example, we recommend a /16 network for the VPC. Note that when changing the size of the network,
# you will have to adjust the 'cidr_subnetwork_width_delta' in the 'vpc_network' -module accordingly.
variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.3.0.0/16"
}

# For the example, we recommend a /16 network for the secondary range. Note that when changing the size of the network,
# you will have to adjust the 'cidr_subnetwork_width_delta' in the 'vpc_network' -module accordingly.
variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.4.0.0/16"
}

variable "public_subnetwork_secondary_range_name" {
  description = "The name associated with the pod subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork."
  type        = string
  default     = "public-cluster"
}

variable "public_services_secondary_range_name" {
  description = "The name associated with the services subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork."
  type        = string
  default     = "public-services"
}

variable "public_services_secondary_cidr_block" {
  description = "The IP address range of the VPC's public services secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. Note: this variable is optional and is used primarily for backwards compatibility, if not specified a range will be calculated using var.secondary_cidr_block, var.secondary_cidr_subnetwork_width_delta and var.secondary_cidr_subnetwork_spacing."
  type        = string
  default     = null
}

variable "gke_ingest_roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
  default     = []
}

variable "registry_name" {
  type        = string
  description = "The name of the Artifact Registry"
}

variable "gcs_bucket_name_landing" {
  type        = string
  description = "Name of GCS Bucket"
}

variable "gcs_bucket_name_transcribed" {
  type        = string
  description = "Name of GCS Bucket"
}

variable "gcs_notif_topic_name" {
  type        = string
  description = "Name of Pub/Sub Topic for GCS Notifications"
}

variable "gke_min_master_version" {
  type        = string
  description = "GKE min master version which is subject to change at GCPs discretion - see: https://cloud.google.com/kubernetes-engine/versioning"
}
