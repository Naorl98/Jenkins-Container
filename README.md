# Jenkins on EC2 with Docker

This project sets up a Jenkins server inside a Docker container and deploys it on an Amazon EC2 instance. It's designed to provide a robust CI/CD environment by leveraging the scalability and flexibility of AWS infrastructure.

## Overview

The configuration uses Docker Compose to manage the Jenkins container with dependencies and mounts necessary volumes for persistence. It interacts with EC2 to ensure that Jenkins can scale and interact with other AWS services.

## Getting Started

### Prerequisites

- AWS account
- Docker installed on your local machine
- Docker Compose installed on your local machine
- AWS CLI configured with appropriate access rights

### Files Included

- `Dockerfile`: Specifies the Jenkins container configuration.
- `docker-compose.yml`: Manages the Jenkins container along with any other necessary services.
- `startup.sh`: Script to set up the environment variables and start the Docker containers.
- `deploy.sh`: Deploys the Docker container to the EC2 instance.
- `build.sh`: Builds the Docker container image.

### Setup and Deployment

1. **Configure AWS CLI**:
   Ensure your AWS CLI is configured with the right credentials and default region. This project requires sufficient permissions to manage EC2 instances, EBS volumes, and other AWS services as needed.

2. **Build the Docker Image**:
   Run the `build.sh` script to build your Jenkins Docker image.
   ```bash
   ./build.sh
   ```

3. **Run Locally**:
   To test locally, you can use `docker-compose up` which will read the `docker-compose.yml`.
   ```bash
   docker-compose up
   ```

4. **Deploy to EC2**:
   Use the `deploy.sh` script to deploy your Jenkins setup to an EC2 instance. This script will handle the setup of the EC2 instance as well as Docker configuration.
   ```bash
   ./deploy.sh
   ```

5. **Initialization**:
   Once deployed, navigate to your EC2's public IP on port 8080 to access the Jenkins interface.

## Customization

You can customize the Dockerfile and docker-compose.yml files according to your needs to include additional plugins or configuration required for Jenkins.

## Maintaining and Updating

To update your Jenkins instance or make changes to the configuration, adjust the Dockerfile or docker-compose.yml as needed and rerun the deployment scripts.

## Security

Ensure that your Jenkins is secured by following best practices such as securing the Jenkins console with a strong password and configuring appropriate security groups in your EC2 settings.

## Conclusion

This project simplifies the process of deploying Jenkins on AWS using Docker, making it easier to manage and scale your CI/CD infrastructure.
