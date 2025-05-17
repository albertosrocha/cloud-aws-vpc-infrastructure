**🇺🇸 English** | [🇧🇷 Português](./README.md)

# AWS VPC Infrastructure with Terraform

This Terraform configuration provisions a complete VPC network infrastructure on AWS, including public and private subnets, a NAT Gateway, Internet Gateway, route tables, and VPC endpoints for S3 and DynamoDB.

## Features

- **VPC** with configurable CIDR block, DNS support, and DNS hostnames.
- **Public and private subnets** distributed across multiple Availability Zones.
- **Internet Gateway** for internet access from public subnets.
- **NAT Gateway** with Elastic IP for internet access from private subnets.
- **Route Tables** for public and private routing.
- **VPC Endpoints** for S3 and DynamoDB, enabling private connectivity.
- **Tagging** of all resources with environment and repository metadata.

**Multi-Account**: Supports provisioning across multiple AWS accounts, typically used to segment environments such as development, staging, and production.

## Variáveis
Make sure to define the following variables in the file `infra/envs/<env>/<env>-parameters.tfvars`.:

| Variável                 | Descrição                                              | Exemplo                            |
|--------------------------|--------------------------------------------------------|------------------------------------|
| `vpc_cidr`               | CIDR block for the VPC                                 | `"10.0.0.0/16"`                    |
| `enable_dns_hostnames`   | Enables or disables DNS hostnames                      | `true`                             |
| `enable_dns_support`     | Enables or disables DNS support                        | `true`                             |
| `environment`            | Name of the environment (e.g., dev, staging, prod)     | `"dev"`                            |
| `repo_url`  (optional)   | URL of the code repository                             | `"https://github.com/org/repo"`    |
| `aws_region`             | AWS region                                             | `"us-east-1"`                      |
| `availability_zones`     | List of availability zones                             | `["us-east-1a", "us-east-1b"]`     |
| `private_subnets_cidrs`  | List of CIDRs for private subnets                      | `["10.0.1.0/24", "10.0.2.0/24"]`   |
| `public_subnets_cidrs`   | List of CIDRs for public subnets                       | `["10.0.101.0/24", "10.0.102.0/24"]`|


## Tags
All resources are tagged with the following standard metadata:

- `Name`
- `cloud:environment`
- `cloud:resource:name`
- `cloud:resource:type`
- `code:repo-url`

## Notes
- The first public subnet is used for the NAT Gateway.
- VPC endpoints are created for essential services (S3 and DynamoDB), allowing private access without traversing the public internet.
- Routing tables are separated by subnet type with appropriate routes.

## Usage

1. **AWS Credentials**

    Ensure your AWS credentials are configured before running Terraform.

1. **Configure Variables**

    The file `infra/envs/dev/dev-parameters.tfvars` contains an example configuration.
    
    Edit the variable values in the appropriate `tfvars` file under `infra/envs/<env>/<env>-parameters.tfvars`.

2. **Terraform**

   ```sh
   cd infra
   terraform init
   terraform plan -var-file=envs/dev/dev-parameters.tfvars -input=false -out=tf-plan-file
   terraform apply -auto-approve -input=false tf-plan-file
   ```

## 🗺️ Roadmap

Below is the planned evolution of this infrastructure project. The goal is to enhance automation, security, and environment segregation through CI/CD pipelines and best practices.

- ✅ Define complete VPC structure using Terraform
- ✅ Parameterize configuration with environment-specific `.tfvars` files
- 🔄 Configure remote backend for Terraform state (e.g., S3)
- 📝 Integrate **GitHub Actions** for CI/CD in development and staging environments
- 📝 Integrate **Bitbucket Pipelines** for CI/CD in production environment

> ✅ Completed 🔄 In Progress 📝 Planned
