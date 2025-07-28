# TERRAFORM
## 📦 Demo 2
This exercise is part of **Module 12**: **Terraform** in the Nana DevOps Bootcamp. The goal is to refactor a monolithic Terraform configuration into reusable and maintainable modules. You will modularize the previously created Terraform project (VPC, Subnet, Security Group, EC2, etc.) by breaking it down into separate components. Each module will define one specific infrastructure resource. This approach promotes reusability, easier maintenance, and better scalability.

## 📌 Objective
- Reconfigure monolithic Terraform configuration into modules.


## 🚀 Technologies Used
- **Terraform**: Infrastructure as Code Tool for managing cloud resources.
- **AWS**: Cloud Provider
- **EC2**: Intance on AWS
- **VPC**: Virtual Private Cloud for networking.
- **IAM**: Manage permissions for AWS resources.
  
   
## 📋 Prerequisites
- Ensure you have an AWS Account.
- You have done the previous Terraform demo.
  
## 🎯 Features
- Refactor monolithic Terraform code into modular components.
- Use input variables and outputs for module communication.
- Reuse modules across environments.
- Apply infrastructure using a centralized main.tf
  
       
## 🏗 Project Architecture



## ⚙️ Project Configuration
# Refactoring the previous Demo into modular components.
1. Extracting variables to variables.tf. Move all variable declarations to a dedicated variables.tf file in the root project directory.
    ```bash
        #Variables
        variable avail_zone {}
        variable vpc_cidr_block { }
        variable subnet_cidr_block { }
        variable env_prefix {}
        variable my_ip {}
        variable instance_type {}
        variable public_key_file_location {}
        variable image_name {}
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/2%20variables%20file.png" width=800 />
    
3. Extracting outputs to outputs.tf Move all outputs to outputs.tf file in the root directory.
    ```bash
      output "ec2_public_ip"{
        value = module.myapp-server.webserver_instance.public_ip
      }
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/3%20outut%20tf%20file.png" width=800 />
    
4. Creating a modules directory to organize reusable components.
   ```bash
   mkdir modules
   ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/4%20modules%20folder%20for%20modules.png" width=800 />
    
6. Creating subfolders for each module: subnet and webserver module.
    ```bash
    mkdir modules/subnet
    mkdir module/webserver
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/5%20create%20modules%20each%20modules%20its%20going%20to%20have%20its%20own%20file.png" width=800 />
    
7. Creating base files in each module main.tf, providers.tf, variables.tf files.
    ```bash
    touch mkdir modules/subnet/main.tf
    touch mkdir modules/subnet/providers.tf
    touch mkdir modules/subnet/variables.tf
    touch mkdir modules/subnet/outputs.tf

    touch mkdir modules/webserver/main.tf
    touch mkdir modules/webserver/providers.tf
    touch mkdir modules/webserver/variables.tf
    touch mkdir modules/webserver/outputs.tf
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/6%20each%20module%20with%20its%20own%20varibale%20output%20proiders%20file.png" width=800 />
    
8. Moving subnet-related resources to subnet/main.tf. Copy the VPC subnet, internet gateway, and default route table resources to modules/subnet/main.tf. Replace hardcoded values with variables.

   ```bash
          #Creating Subnet
          resource "aws_subnet" "myapp-subnet-1"{
            vpc_id = var.vpc_id
            cidr_block = var.subnet_cidr_block
            availability_zone = var.avail_zone
            tags = {
              Name: "${var.env_prefix}-subnet-1"
            }
          }
          
          #Creating Internet Gateway
          resource "aws_internet_gateway" "myapp-igw" {
            vpc_id = var.vpc_id
          
            tags = {
              Name: "${var.env_prefix}-Internet Gateway"
            }
          }
          
          #Using Default Routing Table
          resource "aws_default_route_table" "default-main-rtb" {
            default_route_table_id = var.default_route_table_id
          
            route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.myapp-igw.id
              }
          
              tags = {
                Name: "${var.env_prefix}-default-main-rtb"
              }
          }    
    ```
    <img src="" width=800 />
    
10. Define subnet module variables. Add the following variables to modules/subnet/variables.tf:
    ```bash
      variable avail_zone {}
      variable subnet_cidr_block { }
      variable env_prefix {}
      variable vpc_id {}
      variable default_route_table_id {}
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/9%20adding%20existing%20a%20new%20ariables%20to%20the%20subnet%20variables%20fie.png" width=800 />
    
11. Referencing the subnet module in main.tf. This calls the subnet module from your root main.tf file:

    ```bash
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
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/12%20referencing%20module%20from%20main%20tf%20file.png" width=800 />
    
12. Move EC2-related resources to webserver/main.tf. Group all EC2 instance–related resources, including the security group, key pair, AMI query, and EC2 resource
    ```bash
      #Creating Security Group
      resource "aws_security_group" "myapp-sg" {
        name        = "myapp-sg"
        vpc_id      = var.vpc_id
      
        #SSH ingress rule
        # in case we need a port range we set from port= 0 to_port=22  and the range is opened
        ingress {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = var.my_ip
        }
      
        #HTTP ingress rule
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
          values = [var.image_name]
        }
      
        filter {
          name   = "virtualization-type"
          values = ["hvm"]
        }  
      }
      
      #automating AWS key pair
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
        #Using the output from the module module:
        #<module>.<name of the module in this file>.<name of the output object from the module output file>.<desired object attribute>
        subnet_id = var.subnet_id
      
        # Assigning the EC2 to an SG defined in this file
        vpc_security_group_ids = [aws_security_group.myapp-sg.id]
      
        #Assigning availability_zone
        availability_zone = var.avail_zone
      
        #Assigning a public IP
        associate_public_ip_address =  true
      
        #Associating SSH key
        key_name = aws_key_pair.ssh-key.key_name
      
        tags = {
          Name = "${var.env_prefix}-myapp-server-ec2"
        }
      
        user_data = file("user_data_bootstrap.sh")
      
        #This ensures that every time the user-data bootstrap is modified, the EC2 is destroyed and recreated 
        user_data_replace_on_change = true
      }
    
    ```
    <img src="" width=800 />
    
13. Define webserver module variables
    ```bash
        variable vpc_id {}
        variable my_ip {}
        variable env_prefix {}
        variable image_name {}
        variable public_key_file_location {}
        variable instance_type {}
        variable subnet_id {}
        variable avail_zone {}
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/15%20web%20server%20varibales%20tf%20file.png" width=800 />
    
14. Export the EC2 instance object
    ```bash
            output "webserver_instance" {
            #Exporting EC2 object
            value = aws_instance.myapp-ec2
        }
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/13%20webserver%20output.png" width=800 />
    
15. Referencing the webserver module in main.tf
    ```bash
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

    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/14%20calling%20module%20form%20main%20tf%20file.png" width=800 />
    
16. Initialize and apply Terraform configuration:
    Initialize Terraform to load modules:
    ```bash
      terroform init
    ```
    Run the plan and apply commands:
     ```bash
      terraform plan
      terraform --auto-approve
    ```
