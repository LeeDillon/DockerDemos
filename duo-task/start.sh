#!/bin/bash
# Delete running containers
docker rm -f $(docker ps -qa)
# Create network
docker network create harry
# Build Flask app image
docker build -t duo-task-flask:latest .
# Run Flask app container in the network
docker run -d \
    --network harry \
    --name flask-app \
    duo-task-flask:latest
# Run nginx container in the network
docker run -d \
    --network harry \
    --name nginx \
    --mount type=bind,source=$(pwd)/nginx.conf,target=/etc/nginx/nginx.conf \
    -p 80:80 \
    nginx:alpine
