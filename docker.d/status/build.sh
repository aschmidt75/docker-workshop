#!/bin/bash
sudo apt-get install -y zip
cd status
zip -r ../status.war .
cd ..
sudo docker build -t="rossbachp/status" .
sudo docker run --name=status rossbachp/status
rm status.war
