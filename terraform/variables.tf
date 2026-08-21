variable "project_id" {
  description = "GCP Project ID"
  default     = "track2-day21-2a202601434"
}

variable "region" {
  description = "GCP Region (Taiwan)"
  default     = "asia-east1"
}

variable "machine_type" {
  description = "GCE Machine Type"
  default     = "e2-micro"
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/google_compute_engine.pub"
}
