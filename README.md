# reimagined-broccoli

[![Terrascan](https://github.com/gregsienkiewicz/reimagined-broccoli/actions/workflows/terrascan.yml/badge.svg?branch=main)](https://github.com/gregsienkiewicz/reimagined-broccoli/actions/workflows/terrascan.yml)

OWASP Ottawa November 2023 presentation **DevSecOps: containers, vulnerabilities and SCA**. Recording of the presentation on [YouTube - OWASP Ottawa](https://www.youtube.com/watch?v=f-4tFk0ouKc).

Terraforms AWS resources for containerized [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) on ECS, with image in private ECR.

## -!-IMPORTANT-!- Initial Manual Setup Steps

Before using GitHub Actions to manage any changes, the S3 and DynamoDB resources have to be manually initialized. 

Below are the steps required to manually initialize these AWS resources.

```
 01  nano provider.tf    # "Comment out 'backend s3' section"
 02  terraform workspace new backend
 03  terraform init
 04  terraform apply -var-file=tfvars/backend.tfvars
 05  nano provider.tf    # "Uncomment 'backend s3' section"
 06  terraform init -backend-config=tfvars/backend.tfvars
```
