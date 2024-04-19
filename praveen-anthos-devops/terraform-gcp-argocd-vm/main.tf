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
	name         = "argocd-vm"
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
      "wget https://github.com/argoproj/argo-cd/releases/download/v2.2.5/argocd-linux-amd64 -O argocd",
      "sudo chmod +x argocd",
      "sudo mv /home/niteshsharma12012/argocd /usr/local/bin",
#      "argocd version",
    ]
  }
    
    depends_on = [google_compute_firewall.firewall-externalssh]

}
