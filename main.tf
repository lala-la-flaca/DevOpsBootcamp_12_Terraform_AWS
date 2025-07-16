provider "aws" {
  #region = "us-east-2"
}

#Variables
variable avail_zone {}

variable "cidr_blocks" {
  description = "cidr blocks and names for vpc and subnets"
  type = list(object({
    cidr_block = string
    name = string

  }))
}

variable "environment" {
  description = "name of the environment"
}

# Create a VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name,
    vpc_env: var.environment
  }
}

resource "aws_subnet" "dev-subnet-1"{
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: var.cidr_blocks[1].name
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2"{
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-east-2a"
  tags = {
    Name: "subnet-default-3"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
