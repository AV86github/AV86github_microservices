output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface[*].access_config[0].nat_ip
}

output "vm_count" {
  value = "created ${var.instance_count} VM machines"
}
