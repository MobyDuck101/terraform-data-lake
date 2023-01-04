variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region to use"
}

variable "gke_location" {
  type        = string
  description = "GKE Location, different format to GCS"
}

variable "network_name" {
  type        = string
  description = "Name of VPC Network"
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
variable "gke_min_master_version" {
  type        = string
  description = "GKE min master version which is subject to change at GCPs discretion - see: https://cloud.google.com/kubernetes-engine/versioning"
}

