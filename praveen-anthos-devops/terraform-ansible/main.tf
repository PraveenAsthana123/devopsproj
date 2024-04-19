#1. created a provider block for google.
#2. created a firewall rule for port 80.

#3. created a virtual machine "terraform-ansible" of RHEL 8 OS.
 #3.1. Created a default vpc network with public IP address.
 #3.2. Creates a metadata block to authenticate the server using SSH keys.
 #3.3. Created a remote provisioner block to make the connection with remote server.
 #3.4. Create a local provisioner to run the ansible playbook on remote server.
 
provider "google" {
#  credentials = "${file("account.json")}"
  project     = "${var.project_name}"
  region      = "us-central1"
}

resource "google_compute_firewall" "web-server" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

#resource "google_compute_firewall" "jenkins-server" {
#  name    = "jenkins-firewall"
#  network = "default"
#  allow {
#    protocol = "tcp"
#    ports    = ["8080"]
#  }
#  source_ranges = ["0.0.0.0/0"] 
#  target_tags   = ["jenkins"]
#}

resource "google_compute_instance" "tfansible" {
	name         = "terraform-ansible"
	machine_type = "n1-standard-1"
	zone         = "us-central1-a"
    tags         = ["web"]

	boot_disk {
		initialize_params {
			image = "rhel-cloud/rhel-8"
		}
	}


#    metadata_startup_script = "echo hi > /test.txt"

	network_interface {
		network = "default"
        access_config {
				# Include this section to give the VM an external ip address
		}
	}
	metadata = {
#		ssh-keys = "niteshsharma12012:${file("~/.ssh/id_rsa.pub")}"
        Name     = "Terraform and Ansible Demo"
        ssh-keys = "${var.ssh_user}:${file("${var.public_key_path}")}"        
	}

  #############################################################################
  # This is the 'local exec' method.  
  # Ansible runs from the same host you run Terraform from
  #############################################################################

  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host = "${google_compute_instance.tfansible.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.tfansible.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} playbook1.yaml"
  }

}

