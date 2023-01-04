variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region to use"
}

variable "network_name" {
  type        = string
  description = "Name of VPC Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of VPC Subnet"
}

variable "subnet_name_gpu" {
  type        = string
  description = "Model Training Node Subnet"
}

variable "gcs_location" {
  type        = string
  description = "Global Cloud Storage Bucket Location"
}

variable "gcs_bucket_name_landing" {
  type        = string
  description = "Name of GCS Bucket"
}

variable "gcs_bucket_name_transcribed" {
  type        = string
  description = "Name of GCS Bucket"
}

variable "registry_name" {
  type        = string
  description = "The name of the Artifact Registry"
}
