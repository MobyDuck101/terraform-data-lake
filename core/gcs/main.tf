## Most basic GCS Bucket possible
resource "google_storage_bucket" "datalake-ingest-landing" {
  ## names may contain dots, not slashes
  name     = var.gcs_bucket_name_landing
  location = var.gcs_location
  ## Required by policy constraint (BJSS)
  uniform_bucket_level_access = true
  ##  TODO  - Means cannot use google_storage_bucket_access_control - TBC

  ## So can delete contents with terraform destroy
  force_destroy = true

  ## Lifecycle Rule to Move to Nearline after 45 Days
  #  Alternatively we can just delete the file, aligning with current MTa practice. 
  lifecycle_rule {
    condition {
      age = 45
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  timeouts {
    create = "60m"
  }

  ## TODO - Encryption of H/C Data using CMEK

  ## DO NOT USE (not external facing)
  ##  website
  ##  CORS
}


resource "google_storage_bucket" "datalake-transcribed" {
  ## names may contain dots, not slashes
  name     = var.gcs_bucket_name_transcribed
  location = var.gcs_location
  ## Required by policy constraint
  uniform_bucket_level_access = true
  ##  TODO  - Means cannot use google_storage_bucket_access_control - TBC
  ## So can delete contents with terraform destroy
  force_destroy = true

  ## Lifecycle Rule to Move to Nearline after 45 Days
  #  Alternatively we can just delete the file, aligning with current MTa practice. 
  lifecycle_rule {
    condition {
      age = 45
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  ## TODO - Encryption of H/C Data using CMEK

  ## DO NOT USE (not external facing)
  ##  website
  ##  CORS  
  timeouts {
    create = "60m"
  }
}