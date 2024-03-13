# Define required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">=0.14"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}

# Create a new VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "${local.name_prefix}-VPC"
  }
}

# Add provisioning of the public subnetin the created VPC
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
  }
}

# Add provisioning of the private subnets in the created VPC
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.name_prefix}-private-subnet-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "public_subnets_rt" {
  count = var.env == "dev" ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.name_prefix}-public-RT"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "public_rt_association" {
  count          = var.env == "dev" ? length(aws_subnet.public_subnet[*].id) : 0
  route_table_id = aws_route_table.public_subnets_rt[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_eip" "nat_eip" {
  count = var.env == "dev" ? length(aws_subnet.private_subnet[*].id) : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.env == "dev" ? length(aws_subnet.private_subnet[*].id) : 0
  depends_on = [aws_eip.nat_eip]
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${local.name_prefix}-nat-gw-${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnets_rt" {
  count = var.env == "dev" ? length(aws_subnet.private_subnet[*].id) : 0
  vpc_id = aws_vpc.main_vpc.id
  depends_on = [aws_nat_gateway.nat_gateway]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  tags = {
    Name = "${local.name_prefix}-private-RT-${count.index + 1}"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "private_route_table_association" {
  count = var.env == "dev" ? length(aws_subnet.private_subnet[*].id) : 0
  depends_on = [aws_subnet.private_subnet, aws_route_table.private_subnets_rt]
  route_table_id = aws_route_table.private_subnets_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}





# resource "aws_nat_gateway" "nat_gw" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet[0].id
#   tags = {
#     Name = "${local.name_prefix}-nat-gw-0"
#   }
# }

# # Route table to route add default gateway pointing to NAT Gateway (nat_gw)
# resource "aws_route_table" "private_subnets_rt" {
#   vpc_id = aws_vpc.main_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gw.id
#   }
#   tags = {
#     Name = "${local.name_prefix}-private-subnets-route-table-0"
#   }
# }

# # Associate subnets with the custom route table
# resource "aws_route_table_association" "private_route_table_association" {
#   route_table_id = aws_route_table.private_subnets_rt.id
#   subnet_id      = aws_subnet.private_subnet[0].id
# }

# resource "aws_nat_gateway" "nat_gw" {
#   count          = length(aws_subnet.private_subnet[*].id)
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet[count.index].id
#   tags = {
#     Name = "${local.name_prefix}-nat-gw-${count.index}"
#   }
# }

# # Route table to route add default gateway pointing to NAT Gateway (nat_gw)
# resource "aws_route_table" "private_subnets_rt" {
#   count          = length(aws_nat_gateway.nat_gw[*].id)
#   vpc_id = aws_vpc.main_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gw[count.index].id
#   }
#   tags = {
#     Name = "${local.name_prefix}-private-subnets-route-table-${count.index}"
#   }
# }

# # Associate subnets with the custom route table
# resource "aws_route_table_association" "private_route_table_association" {
#   count          = length(aws_route_table.private_subnets_rt[*].id)
#   route_table_id = aws_route_table.private_subnets_rt[count.index].id
#   subnet_id      = aws_subnet.private_subnet[count.index].id
# }