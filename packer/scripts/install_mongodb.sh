#!/usr/bin/env sh

# Add repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Setup
apt update
apt install -y mongodb-org

sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf

# Run Mongo
systemctl start mongod
systemctl enable mongod
