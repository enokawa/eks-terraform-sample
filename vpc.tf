resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                     = "${var.stage}-vpc"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
  }
}


resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-public-a"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
    "kubernetes.io/role/elb"                 = 1
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-public-b"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
    "kubernetes.io/role/elb"                 = 1
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-public-c"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
    "kubernetes.io/role/elb"                 = 1
  }
}

resource "aws_subnet" "app_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-app-a"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
  }
}

resource "aws_subnet" "app_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-app-b"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
  }
}

resource "aws_subnet" "app_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "${var.stage}-app-c"
    Environment                              = var.stage
    "kubernetes.io/cluster/${var.stage}-app" = "shared"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.stage}-private-a"
    Environment = var.stage
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.stage}-private-b"
    Environment = var.stage
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.stage}-private-c"
    Environment = var.stage
  }
}
