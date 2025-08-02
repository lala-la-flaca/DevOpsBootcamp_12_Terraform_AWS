# TERRAFORM & EKS
## 📦 Demo 3
This exercise is part of **Module 12**: **Terraform** in the Nana DevOps Bootcamp. This project shows how to automate the provisioning of an EKS cluster using **TERRAFORM** modules.
## 📌 Objective
- Automate the EKS cluster with Terraform


## 🚀 Technologies Used
- **Terraform**: Infrastructure as Code Tool for managing cloud resources.
- **AWS**: Cloud Provider
- **EC2**: Intance on AWS
- **VPC**: Virtual Private Cloud for networking.
- **EKS**: Manage Kubernetes cluster.
- **Docker**: Container
- **Git**: Version Control
  
   
## 📋 Prerequisites
- Ensure you have an AWS Account.
- You have done the previous Terraform demo.
  
## 🎯 Features
- Deploy EKS with Terraform
  
       
## 🏗 Project Architecture



## ⚙️ Project Configuration
### Control Plane
1. Switch back to the master branch
2. Clean up configuration
3. Create a new branch
4. Create a VPC.tf file, where you can see all available inputs of the VPC module.
   [Terraform VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
   
6. Add the provider section in the VPC.tf file and define the desired region to use in the project
   ```bash
       provider "aws" {
        region = "us-east-2"
      }
   ```
8. Name the VPC and add the module initialization
   ```bash
     module "myapp-vpc" {
      source  = "terraform-aws-modules/vpc/aws"
      version = "5.1.2"
   }  
   ```
   
9. In the VPC.tf within the module section, pass the values to the input variables of the module. We are building the VPC with the minimum required variables
   ```bash
      name = "myapp-vpc"
      cidr = var.vpc_cidr_block 
   ```
   
   <details><summary><strong>Best Practice:</strong></summary>
     To create at least 1 private subnet and one public subnet in each AZ.
   </details>
   
10. Declare the variables in the VPC.tf file.
  ```bash
    variable vpc_cidr_block {}
    variable private_subnet_cidr_blocks {}
    variable public_subnet_cidr_blocks {}
  ```  
11. Define the value of the variables in the Terraform.tfvars file.
    ```bash
      vpc_cidr_block = "10.0.0.0/16"
      private_subnet_cidr_blocks = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
      public_subnet_cidr_blocks = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
    ```
12. Add the private and public subnets to the VPC module in the VPC.tf file
    ```bash
      private_subnets = var.private_subnet_cidr_blocks
      public_subnets = var.public_subnet_cidr_blocks
    ```
13.  Use data outside of the module section to query the available AZs and add them dynamically depending on each region.
     ``bash
       data "aws_availability_zones" "azs" {}
     ```
14. Add the AZs variable in the vpc.tf file under the vpc module section, to store the values of available AZs. The AZs that is going to retrieve depends on the region defined in the providers section.
    ```bash
      azs = data.aws_availability_zones.azs.names 
    ```
15. Enable NAT gateway for each subnet
    <details><summary><strong>Enable NAT Gateway</strong></summary>
     By default, the NAT gateway is enabled for each subnet.
   </details>
   ```bash
   enable_nat_gateway = true
   ```
    
17. Enable single NAT gateway
    <details><summary><strong>Single NAT Gateway</strong></summary>
     Enables having a shared common NAT gateway for all private subnets. All private subnets route their internet traffic through this single NAT gateway
   </details>
   ```bash
   single_nat_gateway = true
   ```
18. Enable DNS hostnames
  ```bash
    enable_dns_hostnames = true
  ```
19. Add the required tags to identify cluster resources. These tags enable the CCM (cloud controller manager) to identify the resources to be used in the EKS configuration. "myapp-eks-cluster" specifies the name of the cluster.

```bash
  #VPC tag
      tags = {
          "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        }
  #Public Subnet tags with elastic load balancer (public) accessible from Internet
 
      public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = 1
      }
  #Private Subnet tags with internal elastic load balancer
      private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1
      }
```
20. Save and initialize Terraform
```bash
terraform init
```
22. Plan and apply changes
```bash
terraform plan
terraform --auto-approve
```
### EKS Cluster
1. Create the EKS-cluster.tf file using the EKS cluster module
   [Terraform EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
   
2. Add the provision instructions to the eks-cluster.tf file
   ```bash   
      module "eks" {
        source  = "terraform-aws-modules/eks/aws"
        version = "20.37.2" 
      }   
   ```    
3 
### Worker Nodes
### Accessing EKS Cluster using Kubectl

