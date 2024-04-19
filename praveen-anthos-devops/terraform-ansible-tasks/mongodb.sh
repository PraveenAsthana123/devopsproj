#!/bin/bash

#
# MongoDB script
#

# Pre-req: Ubuntu Bionic (18.04) flavored distro
# Note:  To expose your server to the network, set bind to 0.0.0.0 in /etc/mongod.conf
#
# Recommended for first time users:  create a VM, ssh into it, 'wget' the raw version of this gist.

if [ -f /usr/bin/mongod ]; then
  echo "MongoDB is installed on your machine."
  kill -0 "$$" || exit
else
  echo "********************* MongoDB 4.0 INSTALL **************************"
  echo "MongoDB is is not installed."
  echo "You will be prompted several time for input during the install."
  echo "******************************************************************"

  wget -qO- https://www.mongodb.org/static/pgp/server-4.0.asc | sudo bash -c "apt-key add"

  sudo bash -c "echo deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse > /etc/apt/sources.list.d/mongodb-org.list"
  sudo bash -c "apt update && apt upgrade -y"
  sudo bash -c "apt install mongodb-org -y"

  sudo bash -c "apt update && apt upgrade -y"
  sudo bash -c "apt autoremove && apt clean -y"

  sudo bash -c " mkdir /data /data/db"

  sudo bash -c "systemctl enable mongod"  #enables Mongo on system startup
  sudo bash -c "service mongod start"

  sudo bash -c "echo ' ' >> /etc/mongod.conf"
  sudo bash -c "echo 'security:' >> /etc/mongod.conf"
  sudo bash -c "echo '  authorization: enabled' >> /etc/mongod.conf"

  sudo bash -c "service mongod restart"

fi

echo "Script complete."
