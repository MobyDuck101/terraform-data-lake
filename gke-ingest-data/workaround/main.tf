# Required to pull from Artifact Registry
resource "google_project_iam_member" "gke_sa_iam_2" {
  member  = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
  project = var.project_id
  role    = "roles/artifactregistry.reader"
}
# Required to pull from PubSub
resource "google_project_iam_member" "gke_sa_iam_3" {
  member  = "serviceAccount:svacc-gke-ingest-0@${var.project_id}.iam.gserviceaccount.com"
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  depends_on = [google_project_iam_member.gke_sa_iam_2, ]
}