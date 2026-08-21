terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "income-api" {
  name         = "income-api"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["income-api"]

  metadata = {
    ssh-keys = "root:${file(var.ssh_public_key)}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3-pip
    pip3 install fastapi uvicorn scikit-learn joblib google-cloud-storage
    mkdir -p ~/models ~/src
  EOF
}

resource "google_compute_firewall" "allow-income-api" {
  name    = "allow-income-api"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["income-api"]
}
