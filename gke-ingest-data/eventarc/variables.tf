variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
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
