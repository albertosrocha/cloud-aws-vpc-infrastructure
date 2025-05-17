resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name                  = "PRODUCT-VPC"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "PRODUCT-VPC"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                  = "internet-gtw"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "internet-gtw"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidrs)
  cidr_block              = element(var.private_subnets_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                  = "private-subnet-${count.index + 1}-${element(var.availability_zones, count.index)}"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "private-subnet-${count.index}"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.aws_region
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidrs)
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                  = "public-subnet-${count.index + 1}-${element(var.availability_zones, count.index)}"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "private-subnet-${count.index}"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name                  = "nat-eip"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "nat-eip"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_nat_gateway" "nat_gtw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name                  = "nat-gtw"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "nat-gtw"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                  = "private-route-table"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "private-route-table"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                  = "public-route-table"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "public-route-table"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gtw.id
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private_route_table.id,
    aws_route_table.public_route_table.id
  ]
  tags = {
    Name                  = "dynamodb-vpc-endpoint"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "dynamodb-vpc-endpoint"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private_route_table.id,
    aws_route_table.public_route_table.id
  ]
  tags = {
    Name                  = "s3-vpc-endpoint"
    "cloud:environment"   = var.environment
    "cloud:resource:name" = "s3-vpc-endpoint"
    "cloud:resource:type" = "network"
    "code:repo-url"       = var.repo_url
  }
}