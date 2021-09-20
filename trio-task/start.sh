#!/bin/bash
# Delete running containers
docker rm -f $(docker ps -qa)
# Delete running images
# docker rmi -f $(docker images -qa)
# Create network
docker network create trio-network
# Build SQL image 
docker build -t trio-task-mysql:latest db
# Run SQL container
docker run -d \
    --network trio-network \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD=$mysecretpw \
    -e MYSQL_DATABASE=flaskdb \
    trio-task-mysql:latest
# Build Flask app image
docker build -t trio-task-flask:latest flask-app
# Run Flask app container in the network
docker run -d \
    --network trio-network\
    --name flask-app \
    -e mysecretpw=$mysecretpw \
    trio-task-flask:latest
# Run nginx container in the network
docker run -d \
    --network trio-network \
    --name nginx \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    -p 80:80 \
    nginx:alpine

