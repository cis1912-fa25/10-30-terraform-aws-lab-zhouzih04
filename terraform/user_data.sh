#!/bin/bash

sudo yum update -y

sudo systemctl start docker
sudo systemctl enable docker

aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin ${ecr_repository_url}

docker pull ${ecr_repository_url}:latest

docker run -d \
  --name webapp \
  --restart unless-stopped \
  -p 80:80 \
  ${ecr_repository_url}:latest

echo "Webapp deployed successfully at $(date)" >> /var/log/webapp-deployment.log

