Requirement:

1. Create a Server Using terraform and install the PHP and Httpd(web-server) on RHEL-8 OS using ansible.
2. I should have the WEB-URL as OUTPUT Variable in terraform.
3. Clone a git repo using ansible and copy the files in /var/www/html(it is the part of ansible playbook)

Steps to Complete(Solution):

1. Create a RHEL-8 vm using terraform resource.
    #1.1. Created a default vpc network with public IP address.
    #1.2. Creates a metadata block to authenticate the server using SSH keys.
    #1.3. Created a remote provisioner block to make the connection with remote server.
    #1.4. Create a local provisioner to run the ansible playbook on remote server.
2. Create a terraform Resource(Firewall) for web-server port 80.
3. Create a ansible playbook to install php and HTTPD web server using terraform and use the git module to clone the repo with dest /var/www/html.
4. use terraform output variable for web url using http.


---------------------------------------------------------------------------------------------------------------------------
problems we faced while doing the Task

1. │ Error: local-exec provisioner error
│
│   with google_compute_instance.tfansible,
│   on main.tf line 86, in resource "google_compute_instance" "tfansible":
│   86:   provisioner "local-exec" {
│
│ Error running command 'ansible-playbook -i '34.170.253.83,' --private-key ~/.ssh/id_rsa playbook1.yaml': exit status
│ 127. Output: /bin/sh: line 1: ansible-playbook: command not found


