#!/bin/bash

# === CONFIGURATION ===
EC2_USER="ubuntu"
EC2_IP="15.207.223.54"
KEY_PATH="naor.rsa.pem"  # Update this with your actual key file
VERSION="${1:-1.0}"
PACKAGE_NAME="jenkins-naor-startup-package_$VERSION.tar.gz"

echo "🚀 Deployment process started for version $VERSION..."

# === STEP 1: Securely Transfer Deployment Package to EC2 ===
echo "🔹 Transferring package to EC2..."
scp -i $KEY_PATH $PACKAGE_NAME $EC2_USER@$EC2_IP:/home/$EC2_USER/

# === STEP 2: Connect to EC2 and Deploy ===
echo "🔹 Connecting to EC2 and executing deployment..."
ssh -i $KEY_PATH $EC2_USER@$EC2_IP << EOF
    echo "📦 Extracting package..."
    aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 324037305534.dkr.ecr.ap-south-1.amazonaws.com
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo apt update
    sudo apt install git -y
    sudo apt install -y docker.io
    sudo apt install docker-compose -y
    sudo usermod -aG docker ubuntu
    newgrp docker
    sudo chmod 666 /var/run/docker.sock

    sudo apt update && sudo apt install awscli -y

    tar -xzvf /home/$EC2_USER/$PACKAGE_NAME -C /home/$EC2_USER/

    echo "🔄 Cleaning up old containers..."
    docker-compose down
    docker system prune -a -f

    echo "🚀 Starting jenkins with Docker Compose..."
    chmod +x startup.sh
    ./startup.sh
EOF

echo "✅ Deployment completed successfully for version $VERSION!"
