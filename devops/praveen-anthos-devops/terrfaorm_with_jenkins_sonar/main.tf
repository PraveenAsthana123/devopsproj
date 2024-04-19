provider "google" {
 #credentials = "${file("credentials.json")}"
 project     = "gcp-anthos-359617"
 region      = "us-central1"
}

# A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
	name         = "gitlab-terraform-vm"
	machine_type = "n1-standard-2"
	zone         = "us-central1-a"

	boot_disk {
		initialize_params {
			image = "ubuntu-os-cloud/ubuntu-2204-lts"
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

}
    
resource "null_resource" "provisionscript1" {

  provisioner "file" {
    source      = "sonarqube-jenkins.sh"
    destination = "/home/niteshsharma12012/sonarqube-jenkins.sh"
  }

  connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
  }
}

resource "null_resource" "runscript1" {

    connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
	}
    
  provisioner "remote-exec" {
    inline = [
        "/bin/bash /home/niteshsharma12012/sonarqube-jenkins.sh",
        ]
    }

    depends_on = [null_resource.provisionscript1]
}

resource "null_resource" "provisionscript2" {

  provisioner "file" {
    source      = "gitlab-runner.sh"
    destination = "/home/niteshsharma12012/gitlab-runner.sh"
  }

  connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
  }
  depends_on = [null_resource.runscript1]
}

resource "null_resource" "runscript2" {

    connection {
	  type = "ssh"
	  user = "niteshsharma12012"
	  host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
	  private_key = "${file("~/.ssh/id_rsa")}"
	}
    
  provisioner "remote-exec" {
    inline = [
        "/bin/bash /home/niteshsharma12012/gitlab-runner.sh",
        ]
    }

    depends_on = [null_resource.provisionscript2]
}

