#!/usr/bin/env sh

#######################################################################
#   Ruby installation                                                 #
#######################################################################
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential



#######################################################################
#   MongoDB installation                                              #
#######################################################################

# Add repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

# Setup
sudo apt update
sudo apt install -y mongodb-org

# Run Mongo
sudo systemctl start mongod
sudo systemctl enable mongod



#######################################################################
#   Deploy                                                            #
#######################################################################

# Clone src
cd ~
git clone -b monolith https://github.com/express42/reddit.git

# Build
cd reddit && bundle install

# Run
puma -d
