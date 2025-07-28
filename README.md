# TERRAFORM
## 📦 Demo 1
This exercise is part of Module 12: Terraform in the Nana DevOps Bootcamp. The goal is to refactor a monolithic Terraform configuration into reusable and maintainable modules. You will modularize the previously created Terraform project (VPC, Subnet, Security Group, EC2, etc.) by breaking it down into separate components. Each module will define one specific infrastructure resource. This approach promotes reusability, easier maintenance, and better scalability.

## 📌 Objective
- Automate the AWS infrastructure using Infrastructure as Code (IaC)
- Configure Terraform Script to automate deploying Docker Container to EC2


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
- Apply and destroy infrastructure using a centralized main.tf.
  
       
## 🏗 Project Architecture



## ⚙️ Project Configuration
# Refactoring the previous Demo into modular components.
1. Extract all variables to variables.tf file. This file contains all variable definitions of the main project.
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
    <img src="" width=800 />
    
3. Extract all outputs to outputs.tf file. This file contains all the outputs of the main project.
    ```bash
      output "ec2_public_ip"{
      value = module.myapp-server.webserver_instance.public_ip
      }
    ```
    <img src="" width=800 />
    
4. Create a new modules folder.
   ```bash
   mkdir modules
   ```

    <img src="" width=800 />
    
6. Create two new subfolders: subnet and webserver subfolders.
    ```bash
    mkdir modules/subnet
    mkdir module/webserver
    ```
    <img src="" width=800 />
    
7. Create within each subfolder the main.tf, providers.tf, variables.tf files.
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
    <img src="" width=800 />
    
8. Open the subnet/main.tf file and copy and paste the subnet, internet gateway, and default routing table from the previous demo. The idea is to group components. and replace hardcoded         values into variables.

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
    
10. Add the variables used in the subnet/main.tf file in the subnet/variables.tf file.
    ```bash
      variable avail_zone {}
      variable subnet_cidr_block { }
      variable env_prefix {}
      variable vpc_id {}
      variable default_route_table_id {}
    ```
    <img src="" width=800 />
    
11. Reference the module in the main.tf file to access the module components.
    ```bash
      #calling the subnet module
        module "myapp-subnet" {
        
          #Indicating the source of the module, where the files are located
          source = "./modules/subnets"
        
          #passing values to variables in the module
          #Value is comming from tfvars
          avail_zone = var.avail_zone
          subnet_cidr_block = var.subnet_cidr_block
          env_prefix = var.env_prefix
        
          #Value comming from defined resource here
          vpc_id = aws_vpc.myapp-vpc.id
          default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
        }
    ```
    <img src="" width=800 />
    
12. Now group the EC2 Instance resources in the  webserver/main.tf file: security group, key_pair, Querying AMI, EC2.
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
        #Using the output from the module module:
        #<module>.<name of the module in this file>.<name of the output object from the module output file>.<desired object attribute>
        subnet_id = var.subnet_id
      
        #Assiging the Ec2 to a SG defined in this file
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
      
        #This ensures that everytime that user data bootstrap is modified the EC2 is destroyed and recreated 
        user_data_replace_on_change = true
      }
    
    ```
    <img src="" width=800 />
    
13. Create the variables for the webserver module.
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
    <img src="" width=800 />
    
14. We export the full EC2 instance object to be able to use it in the main tf file.
    ```bash
            output "webserver_instance" {
            #Exporting EC2 object
            value = aws_instance.myapp-ec2
        }
    ```
    <img src="" width=800 />
    
15. Use the webserver module in the main.tf file
    ```bash
      #calling the web-server module
      module "myapp-server" {
      
        #Indicating the source of the module, where the files are located
        source = "./modules/webserver"
      
        #passing values to variables in the module
        #Value is comming from tfvars
        avail_zone = var.avail_zone
        env_prefix = var.env_prefix
        my_ip = var.my_ip
        image_name = var.image_name
        public_key_file_location = var.public_key_file_location
        instance_type = var.instance_type
      
        #Variable comming from another module
        subnet_id = module.myapp-subnet.subnet.id  
      
        #Value comming from defined resource here
        vpc_id = aws_vpc.myapp-vpc.id
      }

    ```
    <img src="" width=800 />
    
16. To use the modules, we must initialize the module first before applying configuration.
    ```bash
      terrorfm init
    ```
17. Use terraform plan to see the changes and terraform apply
     ```bash
      terraform plan
      terraform --auto-aprove
    ```
