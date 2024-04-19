####################
## Network - Main ##
####################

# create VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc-custom"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# create public subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "subnet-custom"
  ip_cidr_range = var.network-subnet-cidr
  network       = google_compute_network.vpc.name
  region        = var.gcp_region
}
