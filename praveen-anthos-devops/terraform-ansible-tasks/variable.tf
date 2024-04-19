variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/id_rsa"
}

variable "project_name" {
  description = "Name of your GCP project.  Example: ansible-terraform-218216"
  default     = "gcp-anthos-359617"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "niteshsharma12012"
}

