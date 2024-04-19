#!/bin/bash

if [ ! -f /usr/bin/mongod ]
            then

                sudo curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

                sudo echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

                sudo apt update -y

                sudo apt install mongodb-org -y

                sudo mkdir -p /data/db
    
                sudo chown -R $USER /data/db 
                
                sudo chmod -R go+w /data/db

                sudo systemctl start mongod.service

                sudo systemctl enable mongod

                mongo --eval 'db.runCommand({ connectionStatus: 1 })'

else
  echo "mongo db already installed.  Skipping..."
fi
  mongod
