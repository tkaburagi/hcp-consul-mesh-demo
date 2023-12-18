provider "aws" {
  region = "ap-northeast-1" # 東京リージョンを指定
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_subnet" "eks_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks_subnet_a"
  }
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks_subnet_b"
  }
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0" # 適切なバージョンを指定
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.26"
  subnets         = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]

  vpc_id = aws_vpc.eks_vpc.id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 2
    }
  ]
}
