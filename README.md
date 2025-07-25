# TERRAFORM
## 📦 Demo 1
This project is part of the **Terraform module** in the **TWN DevOps Bootcamp**. It shows how to use **Terraform** to automate the provisioning of **AWS infrastructure**, including a **VPC**, **subnets**, **EC2 instance**, **security groups**, and more.
[GitLab Repo](https://gitlab.com/devopsbootcamp4095512/devopsbootcamp_8_jenkins_pipeline/-/tree/complete_pipeline_EKS_ECR/java-maven-app?ref_type=heads)

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
  
## 🎯 Features
- Install Terraform
- Create Terraform project to automate provisioning AWS infrastructure: EC2, VPC, subnets, Route Table, Internet gateway, Security Group
- Configure the TF script to automate deploying a Docker container to EC2
  
       
## 🏗 Project Architecture



## ⚙️ Project Configuration
### Installing Terraform and Setting Up the Project

1. Install Terraform:
   Follow the Terraform installation guide for your operating system.
   [Install Terraform](https://developer.hashicorp.com/terraform/install)
  
2. Create the Project Folder
   Create a new folder for your Terraform project and navigate into it.
   
3. Install VS Code Terraform Extension
   Open the project in VS Code and install the official Terraform extension for syntax support.
   
4. Create the providers.tf File
   Define the required provider for AWS:
   ```bash
       terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "6.3.0"
        }
      }
    }

   ```
5. Create the main.tf File
   Add the AWS provider configuration (access keys hardcoded for demo purposes only):
   ```bash
     provider "aws" {
        region     = "us-east-2"
        access_key = "xxxxx"
        secret_key = "xxxxxx"
     }
   ```
6. Initialize Terraform:
      Run the following command to download provider plugins and initialize the working directory:
      ```bash
      terraform init
      ```
7. Create a VPC Resource.
     ```bash
       resource "aws_vpc" "dev-vpc" {
         cidr_block = "10.0.0.0/16"
       }    
     ```
     <img src="" width=800 />
     
8. Add a Subnet Resource.
   ```bash
     resource "aws_subnet" "myapp-subnet-1" {
        vpc_id = aws_vpc.dev-vpc.id
        cidr_block = "10.0.10.0/24"
        availability_zone = "us-east-2a"   
    }     
   ```
   <img src="" width=800 />
     
9. Apply Infrastructure.
    ```bash
      terraform plan
      terraform apply
    ```
    <img src="" width=800 />
     
10. Verify on AWS Console:
    Confirm that the VPC and subnet have been created.
 
    <img src="" width=800 />
      
11. Add Subnet to the default VPC:
    ```bash
      data "aws_vpc" "existing_vpc" {
        default = true
      }
  
      resource "aws_subnet" "dev-subnet-2"{
        vpc_id = data.aws_vpc.existing_vpc.id
        cidr_block = "172.31.48.0/20"
        availability_zone = "us-east-2a"  
      }    
    ```
    <img src="" width=800 />
      
12. Add Tags to Resources
    VPC:
      ```bash
        resource "aws_vpc" "dev-vpc" {
          cidr_block = "10.0.0.0/16"
          tags = {
            Name: "dev-vpc"
            vpc_env: "dev"         
          }    
        }
    ```
    Subnet:
    ```bash
      resource "aws_subnet" "myapp-subnet-1" {
        vpc_id = aws_vpc.dev-vpc.id
        cidr_block = "10.0.10.0/24"
        availability_zone = "us-east-2a"
        tags = {
          Name: "subnet-dev-1"         
        }      
    }
    ```
    Default VPC and Subnet2:
    ```bash
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
    ```
    <img src="" width=800 />
      
13. Apply the New Configuration
      ```bash
        terraform plan
        terraform apply
      ```
  
14. Destroy a Specific Resource
      ```bash
      terraform destroy -target aws_subnet.dev-subnet-2
      ```
      <img src="" width=800 />
      
15. Destroy All Resources
      ```bash
      terraform destroy
      ```
      <img src="" width=800 />
16. Clean Up the Project

17. Add a .gitignore file
      ```bash
        # Local terraform directory
        .terraform/*
        
        #Terraform state
        *.tfstate
        *.tfstate.*
        
        #Terraform variables for each user. Every user must have their tvars file copy locally, as this file may include sensitive data
        *tfvars
      ```
      
      <img src="" width=800 />
      
  18. Add a terraform.tfvars File:
      This file stores reusable variable values:
      ```bash
        avail_zone = "us-east-2a"
        vpc_cidr_block = "10.0.0.0/16"
        subnet_cidr_block = "10.0.10.0/24"
        env_prefix = "dev"
      ```
      <img src="" width=800 />
      
  19. Declare Variables in the main.tf file
      ```bash
        #Variables
        variable avail_zone {}
        variable vpc_cidr_block { }
        variable subnet_cidr_block { }
        variable env_prefix {}
      ```
      <img src="" width=800 />
      
  20. Use Variables in Resource Definitions:
      Update the VPC and subnet blocks to use variables.
      VPC:
      ```bash
        resource "aws_vpc" "dev-vpc" {
          cidr_block = var.vpc_cidr_block
          tags = {
            Name: "${env_prefix}-vpc"
            vpc_env: var.env_prefix        
          }    
        }
      ```
      Subnet:
      ```bash
        resource "aws_subnet" "myapp-subnet-1" {
          vpc_id = aws_vpc.dev-vpc.id
          cidr_block = var.subnet_cidr_block
          availability_zone = var.avail_zone
          tags = {
            Name: "${env_prefix}-subnet"         
          }      
        }      
      ```
      <img src="" width=800 />
      
  21. Create an Internet Gateway
      ```bash
        #Creating Internet Gateway
          resource "aws_internet_gateway" "myapp-igw" {
            vpc_id = aws_vpc.myapp-vpc.id
    
            tags = {
              Name: "Internet Gateway"
            }
          }      
      ```
      <img src="" width=800 />
      
  22. Add a Route Table
      ```bash

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

      ```
      <img src="" width=800 />
      
  23. Associate the Route Table with the Subnet
      ```bash
        #Associating subnets with the routing table.
        resource "aws_route_table_association" "a-rtb-subnet"{
            subnet_id = aws_subnet.myapp-subnet-1.id
            route_table_id = aws_route_table.myapp-route-table.id
        }        
      ```
      <img src="" width=800 />
      
  24. Apply changes and verify them in the AWS console:
      ```bash
      terraform plan
      terraform --auto-approve
      ```
      <img src="" width=800 />
      
  25. Use the Default Route Table
      ```bash
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
      ```
      <img src="" width=800 />
  26. Create a Security Group
      ```bash
      #Creating Security Group
      resource "aws_security_group" "myapp-sg" {
          name        = "myapp-sg"
          vpc_id      = aws_vpc.myapp-vpc.id
                    
          #SSH ingress rule
          #To open a port range set different values on the from_port and to_port.
          #SSH
          ingress {
              from_port = 22
              to_port = 22
              protocol = "tcp"
              cidr_blocks = var.my_ip
          }
          #Ingress rule
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
          }
          
          tags = {
              Name: "${var.env_prefix}-MyApp-SG"
            }
          }                 
      ```
      <img src="" width=800 />
      
  27. Query the Latest AMI
      ```bash
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
      ```
      <img src="" width=800 />
      
  28. Create a Shell Script to Install Docker and NGINX
      File: user_data_bootstrap.sh

      ```bash
          #!/bin/bash
          sudo dnf update -y
          sudo dnf install -y docker
          sudo systemctl enable docker
          sudo systemctl start docker
          sudo usermod -aG docker ec2-user
          sleep 10
          sudo docker run -d -p 8080:80 nginx 
      ```
      <img src="" width=800 />
      
  29. Manually create a Key Pair on AWS Console and use it in the EC2
      <img src="" width=800 />

  30. Create EC2 Instance
      ```bash
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
    
        tags = {
          Name = "${var.env_prefix}-myapp-server-ec2"
        }
      
        #User data bootstrap: Script to initialize EC2 instance with docker,nginx     
        user_data = file("user_data_bootstrap.sh")
      
        #This ensures that every time that the user data bootstrap is modified, the EC2 is destroyed and recreated.
        user_data_replace_on_change = true
      }
      ```
      <img src="" width=800 />
      
  31. Create a Key Pair Using Public Key File.
      ```bash
        #automating aws key pair
        resource "aws_key_pair" "ssh-key" {
          key_name = "server-key"
        
          #Reading from file to get the public key
          public_key = file(var.public_key_file_location)
        }
      ```
      <img src="" width=800 />
      
  32. Update EC2 to Use the Automated Key
      ```bash
       #Associating SSH key
       key_name = aws_key_pair.ssh-key.key_name
      ```
      <img src="" width=800 />
      
  33. Apply Changes
      ```bash
      terraform plan
      terraform apply --auto-approve
      ```
      <img src="" width=800 />
      
  34. Verify EC2 Access and NGINX Page
      ```bash
      ```
      <img src="" width=800 />
      




