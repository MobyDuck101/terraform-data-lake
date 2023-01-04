/**
 * EventARC - Publich notification of GCs Event to PubSub
 */

// Enable notifications by giving the correct IAM permission to the unique service account.
data "google_storage_project_service_account" "gcs_account" {
  provider = google-beta
}

// Create a Pub/Sub topic.
resource "google_pubsub_topic_iam_binding" "binding" {
  provider = google-beta
  topic    = google_pubsub_topic.topic.id
  role     = "roles/pubsub.publisher"
  members  = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_pubsub_topic" "topic" { # todo - set as topic name - can I use vars here? 
  name     = var.gcs_notif_topic_name
  provider = google-beta
}

// Create a Pub/Sub notification.
resource "google_storage_notification" "notification" {
  provider       = google-beta
  bucket         = var.gcs_bucket_name_landing
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}

resource "google_pubsub_subscription" "demo-test-sub-landing" {
  ack_deadline_seconds         = "10"
  enable_exactly_once_delivery = "false"
  enable_message_ordering      = "false"

  expiration_policy {
    ttl = "2678400s"
  }

  message_retention_duration = "87000s"
  name                       = "demo-test-sub-landing" # todo - make variable
  project                    = var.project_id
  retain_acked_messages      = "false"
  topic                      = var.gcs_notif_topic_name
  depends_on                 = [google_pubsub_topic.topic]
}