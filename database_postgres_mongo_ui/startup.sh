#!/bin/bash
echo "docker-compose build"
sudo docker-compose build
echo "docker-compose up -d"
sudo docker-compose up -d
sleep 2
echo "docker-compose ps -a"
sudo docker-compose ps -a
