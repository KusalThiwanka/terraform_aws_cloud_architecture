# This is to use Outputs from Remote State
data "terraform_remote_state" "subnet_data" {
  backend = "s3"
  config = {
    bucket = "kusal-assignment1"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}

# Adding SSH  key to instance
resource "aws_key_pair" "devkeypair" {
  key_name   = "devkeypair"
  public_key = file("devkeypair.pub")
}

resource "aws_instance" "pub_ec2" {
  count                       = length(data.terraform_remote_state.subnet_data.outputs.public_subnet_ids)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.devkeypair.key_name
  security_groups             = [aws_security_group.pub_sub_assignment1_sg.id]
  subnet_id                   = data.terraform_remote_state.subnet_data.outputs.public_subnet_ids[count.index]
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-WebServer${count.index + 1}"
    }
  )
}

#security Group
resource "aws_security_group" "pub_sub_assignment1_sg" {
  name        = "allow_http_and_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.subnet_data.outputs.vpc_id
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-pub_sub_assignment1_sg"
    }
  )
}

resource "aws_instance" "private_ec2" {
  count                       = length(data.terraform_remote_state.subnet_data.outputs.private_subnet_ids)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.devkeypair.key_name
  security_groups             = [aws_security_group.private_sub_assignment1_sg.id]
  subnet_id                   = data.terraform_remote_state.subnet_data.outputs.private_subnet_ids[count.index]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-VM${count.index + 1}"
    }
  )
}

#security Group
resource "aws_security_group" "private_sub_assignment1_sg" {
  name        = "allow_http_and_ssh_only_for_admins"
  description = "Allow HTTP and SSH inbound traffic only for Admins"
  vpc_id      = data.terraform_remote_state.subnet_data.outputs.vpc_id
  ingress {
    description      = "HTTP from specific IP addresses"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.pub_sub_assignment1_sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH from specific IP addresses"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.pub_sub_assignment1_sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-private_sub_assignment1_sg"
    }
  )
}