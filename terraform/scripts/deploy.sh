#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(dirname "$SCRIPT_DIR")"

echo "Starting deployment of IntraService to Yandex Cloud..."

# Initialize Terraform
cd "$TERRAFORM_DIR"
terraform init

# Plan deployment
echo "Planning deployment..."
terraform plan -var-file=terraform.tfvars

# Ask for confirmation
read -p "Do you want to apply these changes? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Apply changes
    echo "Applying Terraform configuration..."
    terraform apply -var-file=terraform.tfvars -auto-approve
    
    # Output deployment information
    echo "Deployment completed successfully!"
    echo "API Gateway URL: $(terraform output -raw api_gateway_domain)"
    echo "App Container ID: $(terraform output -raw app_container_id)"
    echo "Agent Container ID: $(terraform output -raw agent_container_id)"
else
    echo "Deployment cancelled."
    exit 1
fi