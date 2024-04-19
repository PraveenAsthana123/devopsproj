#1. created a provider block for google.
#2. created a firewall rule for port 80.

#3. created a virtual machine "terraform-ansible" of RHEL 8 OS.
 #3.1. Created a default vpc network with public IP address.
 #3.2. Creates a metadata block to authenticate the server using SSH keys.
 #3.3. Created a remote provisioner block to make the connection with remote server.
 #3.4. Create a local provisioner to run the ansible playbook on remote server.

# provider block for google 
provider "google" {
#  credentials = "${file("account.json")}"
  project     = "${var.project_name}"
  region      = "us-central1"
}

# creating firewall for web-server
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

# creating firewall rule for jenkins-server
resource "google_compute_firewall" "jenkins-server" {
  name    = "jenkins-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["jenkins"]
}

#creating firewall for mongodb server
resource "google_compute_firewall" "mongodb-server" {
  name    = "mongodb-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["mongodb"]
}

#creating  a vm for installing the packages
resource "google_compute_instance" "tfansible" {
	name         = "terraform-ansible"
	machine_type = "n1-standard-1"
	zone         = "us-central1-a"
    tags         = ["web","jenkins","mongodb"]

	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-1804-lts"
		}
	}


#    metadata_startup_script = "echo hi > /test.txt"

# using the default network

	network_interface {
		network = "default"
        access_config {
				# Include this section to give the VM an external ip address
		}
	}

# creating ssh keys to authenticate the remote serever
	metadata = {
#		ssh-keys = "niteshsharma12012:${file("~/.ssh/id_rsa.pub")}"
        Name     = "Terraform and Ansible Demo"
        ssh-keys = "${var.ssh_user}:${file("${var.public_key_path}")}"        
	}

  #############################################################################
  # This is the 'local exec' method.  
  # Ansible runs from the same host you run Terraform from
  #############################################################################

# using remote provisioner to run the script over remote server

  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host = "${google_compute_instance.tfansible.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

# using local-exec to run the ansible script on remote
  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.tfansible.network_interface.0.access_config.0.nat_ip},' --private-key ${var.private_key_path} playbook1.yaml"
  }

}

