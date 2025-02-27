#!/bin/bash

# === CONFIGURATION ===
AWS_REGION="ap-south-1"  
AWS_ACCOUNT_ID="324037305534"  
ECR_REPOSITORY="jenkins-naor"
VERSION="1.0"  
IMAGE_TAG="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$VERSION"
PACKAGE_NAME="jenkins-naor-startup-package_$VERSION.tar.gz"

# === STEP 1: Authenticate with AWS ECR ===
echo "🔹 Authenticating with AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com || { echo "❌ AWS ECR authentication failed!"; exit 1; }

# === STEP 2: Build the Docker Image ===
echo "🔹 Building the jenkins Docker image..."
docker build -t jenkins-naor . || { echo "❌ Docker build failed!"; exit 1; }

# === STEP 3: Tag the Image for ECR ===
echo "🔹 Tagging the image..."
docker tag jenkins-naor:latest $IMAGE_TAG

# === STEP 4: Re-authenticate before pushing to ECR ===
echo "🔹 Re-authenticating with AWS ECR before push..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com || { echo "❌ AWS ECR authentication failed before push!"; exit 1; }

# === STEP 5: Push the Image to ECR ===
echo "🔹 Pushing the image to AWS ECR..."
docker push $IMAGE_TAG || { echo "❌ Docker push failed!"; exit 1; }

# === STEP 6: Create Deployment Archive ===
echo "🔹 Creating deployment package ($PACKAGE_NAME)..."
tar -czvf $PACKAGE_NAME docker-compose.yml startup.sh || { echo "❌ Deployment packaging failed!"; exit 1; }

echo "✅ Build and packaging completed successfully!"
echo "🚀 Image pushed to: $IMAGE_TAG"
echo "📦 Deployment package saved as: $PACKAGE_NAME"
