#!/bin/bash

echo "installing nodejs"

sudo apt-get update -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v

echo "Download and Install Sonar Scanner on Linux"

mkdir /downloads/sonarqube -p
cd /downloads/sonarqube
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
sudo apt install unzip -y
unzip sonar-scanner-cli-4.2.0.1873-linux.zip
sudo mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner


echo "add lines in sonar-scanner.properties"

echo "sonar.host.url=http://localhost:9000" >> /opt/sonar-scanner/conf/sonar-scanner.properties
echo "sonar.sourceEncoding=UTF-8" >> /opt/sonar-scanner/conf/sonar-scanner.properties


echo "create a file to automate the required environment variables configuration"

sudo touch /etc/profile.d/sonar-scanner.sh

sudo chmod 777 /etc/profile.d/sonar-scanner.sh
sudo cat << EOF >> /etc/profile.d/sonar-scanner.sh
#!/bin/bash
export PATH="$PATH:/opt/sonar-scanner/bin
EOF

source /etc/profile.d/sonar-scanner.sh

sonar-scanner -v