#/bin/bash -x

DIR_PATH="/home/ubuntu"
JAVA_VERSION=$(java -version 2>&1 | grep 'java version' | grep -o 1.8)

sudo apt-get update
if [[ -z $JAVA_VERSION  ]] 
then
	sudo apt-get install openjdk-8-jre-headless -y
fi
mkdir -p $DIR_PATH/elasticsearch
cd !$
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.deb
sudo dpkg -i elasticsearch-6.2.4.deb
