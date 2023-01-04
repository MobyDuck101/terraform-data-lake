##GCS Errors Encountered. 
## Only the Service Account may Access this bucket, and access may only be Read Only. 
## Currently failing with this error
#module.google_global_cloud_storage.google_storage_bucket_access_control.public_rule: Creating...
#╷
#│ Error: Error creating BucketAccessControl: googleapi: Error 400: Invalid argument., invalid
#│
#│   with module.google_global_cloud_storage.google_storage_bucket_access_control.public_rule,
#│   on gcs\main.tf line 11, in resource "google_storage_bucket_access_control" "public_rule":
#│   11: resource "google_storage_bucket_access_control" "public_rule" {
# Explanation
# Actual Behavior
# Cannot create a google storage bucket with bucket_policy_only=true (NOW uniform_bucket_level_access = true) together with access controls set to public-read.
# HOWEVER: If I (1) first use the script with bucket_policy_only=false instead --> it creates everything correctly. Then, (2) I adapt the script to bucket_policy_only=true and apply the changes --> Now the endresult is reached. (because apparently no deprecated ACL api endpoints are called now)  
#resource "google_storage_bucket_access_control" "public_rule" {
#  bucket = google_storage_bucket.bucket.name
#  ## This is optional
#  role   = "READER"
#  entity = "new-terraform@nlp-dev-6aae.iam.gserviceaccount.com"
#  # entity = "allAuthenticatedUsers"
#  # entity = "allUsers"
#}
## Have confirmed it is possible to create acess control via GCP Console so this is a Terraform issue. 
##GCS Redundant Extras
#resource "google_storage_bucket" "datalake-ingest-ko" {
#  ## names may contain dots, not slashes
#  name     = "datalake-ingest-ko"
#  location = var.gcs_location
#}
#resource "google_storage_bucket" "datalake-ingest-md-enrichment" {
#  ## names may contain dots, not slashes
#  name     = "datalake-ingest-md-enrichment"
#  location = var.gcs_location
#}
#resource "google_storage_bucket" "datalake-ingest-audio-codec" {
#  ## names may contain dots, not slashes
#  name     = "datalake-ingest-audio-codec"
#  location = var.gcs_location
#}
#resource "google_storage_bucket" "datalake-ingest-process-metadata" {
#  ## names may contain dots, not slashes
#  name     = "datalake-ingest-process-metadata"
#  location = var.gcs_location
#}
