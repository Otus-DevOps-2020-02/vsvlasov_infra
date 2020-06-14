variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "instance_count" {
  description = "Instances count"
  default     = 1
}

variable "db_url" {
  description = "MongoDB URL"
}

variable "enable_provisioning" {
  description = "Flag to enable/disable provisioning"
  default     = false
}
