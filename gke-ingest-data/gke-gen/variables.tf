variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region to use"
}

variable "cluster_name" {
  type        = string
  description = "The cluster to use"
}

variable "subnet_name" {
  type        = string
  description = "The subnet to use"
}

variable "gke_location" {
  type        = string
  description = "GKE Location, different format to GCS"
}

variable "network_name" {
  type        = string
  description = "Name of VPC Network"
}

variable "machine_type" {
  type        = string
  description = "GKE Cluster Node Machine Type"
}

variable "node_name" {
  type        = string
  description = "Node Name"
}

variable "gke_ingest_roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
  default     = []
}
variable "gke_min_master_version" {
  type        = string
  description = "GKE min master version which is subject to change at GCPs discretion - see: https://cloud.google.com/kubernetes-engine/versioning"
}


