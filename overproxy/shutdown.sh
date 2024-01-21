#!/bin/bash
sudo docker-compose stop
sudo docker-compose down -v
sudo docker-compose rm -vf
# sudo docker image prune -a
# sudo docker buildx prune -a
