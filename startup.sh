#!/bin/bash

echo "🔄 Cleaning up old containers..."
docker-compose down
docker system prune -a -f

echo "🚀 Pulling the latest images from ECR..."
sudo docker pull 324037305534.dkr.ecr.ap-south-1.amazonaws.com/jenkins-naor:1.0

echo "🚀 Starting Lavagna with Docker Compose..."
sudo docker-compose up -d
