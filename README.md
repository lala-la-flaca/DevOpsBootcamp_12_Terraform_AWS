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
   Create a new folder for your Terraform project and add a main.tf file.
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/01%20Cretaing%20main%20terraform%20file.png" width=800 />
   
3. Install VS Code Terraform Extension
   Open the project in VS Code and install the official Terraform extension for syntax support.
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/02%20Visual%20studio%20install%20terraform%20plugin.png" width=800 />
   
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
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/03%20defining%20providers.png" width=800 />
   
5. Add the provider to the main.tf file
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/04%20initializing%20terraform%20installing%20providers.png" width=800 />
      
7. Create a VPC Resource.
     ```bash
       resource "aws_vpc" "dev-vpc" {
         cidr_block = "10.0.0.0/16"
       }    
     ```
     
8. Add a Subnet Resource.
     ```bash
       resource "aws_subnet" "myapp-subnet-1" {
          vpc_id = aws_vpc.dev-vpc.id
          cidr_block = "10.0.10.0/24"
          availability_zone = "us-east-2a"   
      }     
     ```
     <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/05%20adding%20subnet%20and%20referecing%20the%20vpc.png" width=800 />
     
9. Apply Infrastructure.
    ```bash
      terraform plan
      terraform apply
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/06%20applying%20resources.png" width=800 />
     
10. Verify on AWS Console:
    Confirm that the VPC and subnet have been created.
 
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/09%20vpc%20has%20been%20created%20in%20AWS%20account.png" width=800 />
      
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
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10%20adding%20a%20subnet%20in%20the%20exising%20resource.png" width=800 />
      
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
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/12%20adding%20tags%20to%20name%20resources.png" width=800 />
      
13. Apply the New Configuration
      ```bash
        terraform plan
        terraform apply
      ```
  
14. Destroy a Specific Resource
      ```bash
      terraform destroy -target aws_subnet.dev-subnet-2
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/16%20destroying%20resource%20via%20command%20terraform%20destroy.png" width=800 />
      
15. Destroy All Resources
      ```bash
      terraform destroy
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/19%20destroy%20all%20resoruces%20cleans%20up.png" width=800 />
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
      
  18. Add a terraform.tfvars File:
      This file stores reusable variable values:
      ```bash
        avail_zone = "us-east-2a"
        vpc_cidr_block = "10.0.0.0/16"
        subnet_cidr_block = "10.0.10.0/24"
        env_prefix = "dev"
      ```
      
  19. Declare Variables in the main.tf file
      ```bash
        #Variables
        variable avail_zone {}
        variable vpc_cidr_block { }
        variable subnet_cidr_block { }
        variable env_prefix {}
      ```
      
  20. Use Variables in Resource Definitions:
      Update the VPC and subnet blocks to use variables.
      VPC:
      ```bash
        resource "aws_vpc" "dev-vpc" {
          cidr_block = var.vpc_cidr_block
          tags = {
            Name: "${var.env_prefix}-vpc"     
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
            Name: "${var.env_prefix}-subnet"         
          }      
        }      
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1001%20cleaning%20file%20adding%20variables%20and%20tags%20using%20variables.png" width=800 />
      
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1003%20cretaing%20internet%20gateway%20and%20routing%20table.png" width=800 />
      
  23. Associate the Route Table with the Subnet
      ```bash
        #Associating subnets with the routing table.
        resource "aws_route_table_association" "a-rtb-subnet"{
            subnet_id = aws_subnet.myapp-subnet-1.id
            route_table_id = aws_route_table.myapp-route-table.id
        }        
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1005%20associating%20subnet%20to%20routing%20table.png" width=800 />
      
  24. Apply changes and verify them in the AWS console:
      ```bash
      terraform plan
      terraform --auto-approve
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1004%20routing%20table%20avaiable%20aws.png" width=800 />
      
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1008%20using%20defaut%20routin%20table%20instead.png" width=800 />
      
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/1009%20cretaing%20segurity%20groups.png" width=800 />
      
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10011%20locating%20the%20owner%20AMI.png" width=800 />
      
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
      
  29. Manually create a Key Pair on AWS Console and use it in the EC2

  30. Copy the file .pem to the .ssh folder
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10013%20%20copy%20file%20to%20.ssh%20folder.png" width=800 />
      
  31. Assign read-only permission to the .pem file
      ```bash
        chmod 400 myapp-server-key-pair.pem
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10014%20assigning%20read%20only%20permission.png" width=800 />
      <details><summary><strong> Important .PEM File Permission ❗❗❗</strong></summary>
        If the file does not have the right permission (read-only), AWS does not allow SSH.
      </details>

  33. Create EC2 Instance
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
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10014%20creating%20Ec2%20instance%20and%20its%20parameters.png" width=800 />
      
  34. Apply changes and verify the EC2 instance
      ```bash
      terraform plan
      terrafom --auto-approve
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10016%20Ec2%20up%20and%20running.png" width=800 />
      
  35. SSH to the EC2 using the .pem file
      ```bash
        ssh -i ~/.ssh/my-key-server.pem ec2-user@18.224.7.198
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10017%20SSH%20to%20Ec2%20using%20the%20rsa%20key%20file.png" width=800 />
      
  36. Create a Key Pair Using Public Key File.
      ```bash
        #automating aws key pair
        resource "aws_key_pair" "ssh-key" {
          key_name = "server-key"
        
          #Reading from file to get the public key
          public_key = file(var.public_key_file_location)
        }
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10019%20automating%20getting%20key.png" width=800 />
      
  37. Update EC2 to Use the Automated Key
      ```bash
       #Associating SSH key
       key_name = aws_key_pair.ssh-key.key_name
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10020%20associaitng%20key.png" width=800 />
      
  38. Apply Changes
      ```bash
      terraform plan
      terraform apply --auto-approve
      ```
      
  39. Verify EC2 Access and NGINX Page
      ```bash
        ssh ec2-user@18.217.147.160
        docker ps
      ```
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10025%20nginx%20deployed%20docker%20ps%20ok.png" width=800 />
      <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/main/Img/10024%20nginx%20deployed%20using%20user%20data.png" width=800 />


      




