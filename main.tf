provider "aws" {
  region = "us-east-2"
  
}

#Variables
variable avail_zone {}
variable vpc_cidr_block { }
variable subnet_cidr_block { }
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable public_key_file_location {}


# Creating VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

#Creating Subnet
resource "aws_subnet" "myapp-subnet-1"{
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}

#Creating Internet Gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name: "Internet Gateway"
  }
}
/*
#Creating Routing Table
resource "aws_route_table" "myapp-route-table"{
  vpc_id = aws_vpc.myapp-vpc.id

#Define each Route
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name: "${var.env_prefix}-rtb"
  }

}

#Associating subnets with the routing table.
resource "aws_route_table_association" "a-rtb-subnet"{
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

*/

#Using Default Routing Table
resource "aws_default_route_table" "default-main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
      Name: "${var.env_prefix}-default-main-rtb"
    }
}

#Creating Security Group
resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  vpc_id      = aws_vpc.myapp-vpc.id

  #SSH ingres rule
  # in case we need a port rage we set from port= 0 to_port=22  and the range is opened
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.my_ip
  }

  #HTTP ingres rule
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"

    #It's a string list
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Egress Rules (Exit)
  egress {
    #Any port
    from_port = 0
    to_port = 0
    #-1 Any protocol
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    #prefix_list_ids - (Optional) List of Prefix List IDs. Any in this case
    prefix_list_ids = []
  }

  tags = {
      Name: "${var.env_prefix}-MyApp-SG"
    }
}

#Querying AMI
data "aws_ami" "Lastest-Amazon-Linux-image" {
  most_recent = true
  owners = ["137112412989"] # Amazon
  #owners = ["amazon"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-2023.8.20250707.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}

output "aws-ami_id" {
   value = data.aws_ami.Lastest-Amazon-Linux-image.id
  }


#automating aws key pair
resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"

  #Reading from file to get the public key
  public_key = file(var.public_key_file_location)


}

#Creating EC2 instance
resource "aws_instance" "myapp-ec2" {
  ami           = data.aws_ami.Lastest-Amazon-Linux-image.id
  instance_type = var.instance_type

  #Assigning the subnet
  subnet_id = aws_subnet.myapp-subnet-1.id

  #Assiging the Ec2 to a SG
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]

  #Assigning availability_zone
  availability_zone = var.avail_zone

  #Assigning a public IP
  associate_public_ip_address =  true

  #Associating SSH key manually
  #key_name = "myapp-server-key-pair"

  #Associating SSH key
  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-myapp-server-ec2"
  }

  #User data bootstrap: Script to initialize EC2 instance with docker,nginx
  /*user_data = <<-EOF
                #!/bin/bash
                exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
                sudo dnf update -y
                sudo dnf install -y docker
                sudo systemctl enable docker
                sudo systemctl start docker
                sudo usermod -aG docker ec2-user
                
                sleep 10

                sudo docker run -d -p 8080:80 nginx 
  
              EOF*/

  user_data = file("user_data_bootstrap.sh")

#This ensures that everytime that user data bootstrap is modified the EC2 is destroyed and recreated 
user_data_replace_on_change = true
}

output "ec2_public_ip"{

  value = aws_instance.myapp-ec2.public_ip
}
