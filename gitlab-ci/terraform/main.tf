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

resource "google_compute_instance" "gitlab" {
  count = var.instance_count
  name         = "gitlab-${count.index}"
  machine_type = "n1-standard-1"
  zone         = var.gcp_zone
  description  = "Gitlab-ci server"
  tags         = ["gitlab", "http-server", "https-server"]
  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
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

  # Provisioners connection
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "gcp"
    agent = false
    # путь до приватного ключа
    private_key = file(var.provisioner_ssh_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -L 'https://github.com/docker/compose/releases/download/1.26.2/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
    ]
  }

}

resource "google_compute_address" "app_ip" {
  name = "gitlab-app-ip"
}
