# IntraService Terraform Deployment

Terraform configuration for deploying IntraService to Yandex Cloud Serverless Containers.

## Prerequisites

1. Yandex Cloud CLI configured
2. Terraform 1.0+
3. Docker images built and pushed to Yandex Container Registry

## Setup

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Fill in required variables
3. Run deployment script:

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```


