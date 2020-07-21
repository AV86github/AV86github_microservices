variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable gcp_zone {
  description = "Zone for gcp VM"
  default     = "europe-west1-b"
}
variable instance_count {
  description = "Docker host count"
  default     = 1
}
