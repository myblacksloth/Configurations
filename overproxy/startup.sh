#!/bin/bash

# alias k='tar xvJf proxyfulltester.txz && cd proxyfulltester'
# use script inside directory

sudo docker-compose build proxy1
sudo docker-compose build proxy2
sudo docker-compose up -d proxy1
sudo docker-compose up -d proxy2
sudo docker-compose build proxycentos
sudo docker-compose up -d proxycentos
sudo docker-compose ps -a
