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