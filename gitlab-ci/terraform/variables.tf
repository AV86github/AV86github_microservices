variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable gcp_zone {
  description = "Zone for gcp VM"
  default     = "europe-west1-b"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable disk_size {
  description = "Disk size"
  default = 50
}
variable instance_count {
  description = "VM count for LB instance group"
  default     = 1
}
variable provisioner_ssh_key {
  description = "Path to ssh key for VM"
}
