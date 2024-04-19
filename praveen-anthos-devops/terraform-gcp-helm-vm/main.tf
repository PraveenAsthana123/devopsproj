provider "google" {
 project     = "gcp-anthos-359617"
 region      = "us-central1"
}

resource "google_compute_firewall" "firewall-externalssh" {
  name    = "firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}


# A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
	name         = "helm-vm"
	machine_type = "n1-standard-2"
	zone         = "us-central1-a"
    tags         = ["externalssh"]

	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-1804-lts"
		}
	}

	network_interface {
		network = "default"
		access_config {
				# Include this section to give the VM an external ip address
		}
	}
	metadata = {
		ssh-keys = "niteshsharma12012:${file("~/.ssh/id_rsa.pub")}"
	}

	
    provisioner "remote-exec" {
      connection {
		type = "ssh"
		user = "niteshsharma12012"
		host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
		private_key = "${file("~/.ssh/id_rsa")}"
	}
    inline = [
      "sudo apt-get update -y",
      "wget -O helm.tar.gz https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz",
      "tar -zxvf helm.tar.gz",
      "sudo mv /home/niteshsharma12012/linux-amd64/helm /usr/local/bin/helm",
      "helm version",
    ]
  }
    
    depends_on = [google_compute_firewall.firewall-externalssh]

}
