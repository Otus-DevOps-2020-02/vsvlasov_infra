terraform {
  required_version = "~>0.12"
}

provider "google" {
  version = "~>2.5.0"

  project = var.project
  region  = var.region
}

resource "google_compute_project_metadata" "ssh-keys" {
  metadata = {
    ssh-keys = <<EOF
      appuser:${file(var.public_key_path)}
      appuser1:${file(var.public_key_path)}
EOF
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["reddit-app"]
  count        = var.instance_count

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "9292"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [
    "reddit-app"
  ]
}
