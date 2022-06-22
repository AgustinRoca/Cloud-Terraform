resource "google_pubsub_topic" "tasks" {
  name = var.topic_name
}

resource "google_pubsub_subscription" "tasks" {
  name  = var.subscription_name
  topic = google_pubsub_topic.tasks.name
  ack_deadline_seconds = 20
}
