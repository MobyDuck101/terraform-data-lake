locals {
  bucket_name_landing = "${var.project_id}_${var.gcs_bucket_name_landing}" 
  bucket_name_transcribed = "${var.project_id}_${var.gcs_bucket_name_transcribed}" 
}