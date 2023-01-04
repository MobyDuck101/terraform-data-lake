## Artifact Registry - Part of CI/CD PIPELINE
# No known TF for Cloud Build
# No apparent Terraformer capability for artefact registry.  
resource "google_artifact_registry_repository" "nle-repo" {
  ## PlayPen-PreReqs: please uncomment line below so that GCP Providder 4.21 works 
  #provider      = google-beta
  location      = var.region
  project       = var.project_id
  repository_id = var.registry_name
  description   = "Docker repository for NLE GCP Prototpye Data Lake"
  format        = "DOCKER"
}