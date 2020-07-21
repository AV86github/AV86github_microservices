terraform {
  # Версия terraform
  required_version = " ~>0.12.8"
}

provider "google" {
  # Версия провайдера
  version = "~> 2.15"

  # ID проекта
  project = var.project

  region = var.region
}


resource "google_compute_instance" "app" {
  count = var.instance_count
  name         = "docker-host-${count.index}"
  machine_type = "g1-small"
  zone         = var.gcp_zone
  tags         = ["docker-host"]
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "gcp:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
}

resource "google_compute_address" "app_ip" {
  name = "docker-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["docker-host"]
}
