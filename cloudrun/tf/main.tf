provider "google" {
  project = "peak-elevator-237302"
  region  = "us-central1"
}

resource "google_cloud_run_service" "default" {
  name     = "hello-world-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/peak-elevator-237302/my-api-spring" // コンテナイメージのパスを指定してください
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
