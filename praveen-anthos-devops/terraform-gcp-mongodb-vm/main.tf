provider "google" {
 #credentials = "${file("credentials.json")}"
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

resource "google_compute_firewall" "firewall-mongodb" {
  name    = "firewall-mongodb"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalmongodb"]
}

# A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
	name         = "mongodb-vm"
	machine_type = "n1-standard-2"
	zone         = "us-central1-a"
    tags         = ["externalssh","externalmongodb"]

	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-1804-lts"
		}
	}
	# Use an existing disk resource

	#metadata_startup_script = "${file("mongodb.sh")}"

	network_interface {
		network = "default"
        access_config {
				# Include this section to give the VM an external ip address
		}
	}
	metadata = {
		ssh-keys = "niteshsharma12012:${file("~/.ssh/id_rsa.pub")}"
	}

}
    
resource "null_resource" "provisionmongoscript" {

  provisioner "file" {
    source      = "mongodb.sh"
    destination = "/tmp/mongodb.sh"
  }

  connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
  }
 depends_on = [google_compute_firewall.firewall-externalssh,google_compute_firewall.firewall-mongodb]
}

resource "null_resource" "runmongoscript" {

    connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
	}
    
  provisioner "remote-exec" {
    inline = [
        "/bin/bash /tmp/mongodb.sh",
        ]
    }

    depends_on = [null_resource.provisionmongoscript]
}