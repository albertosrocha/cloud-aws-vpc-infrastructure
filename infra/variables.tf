variable "environment" {
  type = string
  description = "The name of the environment"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the VPC in"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the vpc"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = false
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
  default     = true
}

variable "repo_url" {
  type = string
  description = "The url of the repo to clone"
  default = "https://github.com/albertosrocha/cloud-aws-vpc-infrastructure"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to use in the region"
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}
