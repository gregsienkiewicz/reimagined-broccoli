# reimagined-broccoli

OWASP Ottawa November 2023 presentation **DevSecOps: containers, vulnerabilities and SCA**

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
