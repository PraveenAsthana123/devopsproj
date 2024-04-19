##############################
## GCP Provider - Variables ##
##############################

# define GCP project name
variable "gcp_project" {
  type        = string
  description = "GCP project name"
}

# define GCP region
variable "gcp_region" {
  type        = string
  description = "GCP region"
}

# define GCP region
variable "gcp_zone" {
  type        = string
  description = "GCP zone"
}
