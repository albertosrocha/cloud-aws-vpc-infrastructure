environment             = "dev"
vpc_cidr                = "172.16.0.0/16"
enable_dns_support      = true
enable_dns_hostnames    = false
availability_zones      = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
private_subnets_cidrs   = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
public_subnets_cidrs    = ["172.16.7.0/24", "172.16.8.0/24", "172.16.9.0/24"]
