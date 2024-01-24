#!/bin/bash
echo "docker-compose stop"
sudo docker-compose stop
echo "docker-compose down -v"
sudo docker-compose down -v
echo "docker-compose rm -vf"
sudo docker-compose rm -vf
