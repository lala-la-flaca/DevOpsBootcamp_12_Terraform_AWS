provider "aws" {
  region = "us-east-2"  
}

# Creating VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

#calling the subnet module
module "myapp-subnet" {

  #Indicating the source of the module, where the files are located
  source = "./modules/subnets"

  #passing values to variables in the module
  #Value is coming from tfvars
  avail_zone = var.avail_zone
  subnet_cidr_block = var.subnet_cidr_block
  env_prefix = var.env_prefix

  #Value coming from defined resource here
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

#calling the web-server module
module "myapp-server" {

  #Indicating the source of the module, where the files are located
  source = "./modules/webserver"

  #passing values to variables in the module
  #Value is coming from tfvars
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  image_name = var.image_name
  public_key_file_location = var.public_key_file_location
  instance_type = var.instance_type

  #Variable coming from another module
  subnet_id = module.myapp-subnet.subnet.id  

  #Value coming from defined resource here
  vpc_id = aws_vpc.myapp-vpc.id
}

