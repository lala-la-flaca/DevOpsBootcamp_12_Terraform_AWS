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
### Creating VPC
1. Switch to the master branch
   ```bash
     git checkout main
   ```
   <img src="" width=800/>
   
2. Clean up the previous configuration
   
3. Create a new branch
   ```bash
     git checkout -b features/eks
   ```
  
4. Create VPC.tf file, where we are going to use the VPC module available here:  
   🔗[Terraform VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
   
5. Add the AWS provider and specify the region to use in the project. In the VPC.tf file:
   ```bash
       provider "aws" {
        region = "us-east-2"
      }
   ```
  <img src="" width=800/>
  
6. Initialize the VPC module. In the VPC.tf, add the module block
   ```bash
       module "myapp-vpc" {
          source  = "terraform-aws-modules/vpc/aws"
          version = "5.1.2"
       }  
   ```
   <img src="" width=800/>
   
7. Configure the name of the VPC and the CIDR block.
   ```bash
      name = "myapp-vpc"
      cidr = var.vpc_cidr_block 
   ```
   <img src="" width=800/>
   
   <details><summary><strong>Best Practice:</strong></summary>
     Create at least one private subnet and one public subnet in each availability zone (AZ)
   </details>
   
8. Declare variables in the VPC.tf file.
   ```bash
      variable vpc_cidr_block {}
      variable private_subnet_cidr_blocks {}
      variable public_subnet_cidr_blocks {}
   ```
   <img src="" width=800/> 
  
9. Assign variable values in the terraform.tfvars
    ```bash
      vpc_cidr_block = "10.0.0.0/16"
      private_subnet_cidr_blocks = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
      public_subnet_cidr_blocks = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
    ```
    <img src="" width=800/>
    
10. Add private and public subnets in the vpc.tf
    ```bash
      private_subnets = var.private_subnet_cidr_blocks
      public_subnets = var.public_subnet_cidr_blocks
    ```
    <img src="" width=800/>
    
11.  Query available availability zones (AZs) to use them dynamically. Use the aws_availability_zones data block outside of the module section
     ```bash
        data "aws_availability_zones" "azs" {}
     ```
     <img src="" width=800/>

12. Pass available AZs to the module, inside the module block in the vpc.tf:
    ```bash
      azs = data.aws_availability_zones.azs.names 
    ```
    <details><summary><strong> Available AZs.</strong></summary> The list of AZs depends on the region defined in the provider block. </details>

    <img src="" width=800/>
    
13. Enable NAT Gateway for each subnet
    
    <details><summary><strong>Enable NAT Gateway</strong></summary>
     By default, the NAT gateway is enabled for each subnet.
   </details>
   
   ```bash
     enable_nat_gateway = true
   ```
  <img src="" width=800/>
    
14. Enable single NAT gateway
    <details><summary><strong>Single NAT Gateway</strong></summary>
      Route all private subnet traffic through a shared NAT gateway to access Internet.</details>
   
     ```bash
       single_nat_gateway = true
     ```
     <img src="" width=800/>
     
15. Enable DNS hostnames
    ```bash
      enable_dns_hostnames = true
    ```
    <img src="" width=800/>

16. Tag the VPC and subnets for Kubernetes and EKS. These tags allow the EKS Cloud Controller Manager (CCM) to discover and manage resources.

    ```bash
      #VPC tag
          tags = {
              "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
            }
      #Public Subnet tags
     
          public_subnet_tags = {
            "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
            "kubernetes.io/role/elb" = 1
          }
      #Private Subnet tags ( internal load balancer)
          private_subnet_tags = {
            "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
            "kubernetes.io/role/internal-elb" = 1
          }
    ```
    <img src="" width=800/>
    
17. Initialize Terraform
    ```bash
      terraform init
    ```
18. Plan and apply changes
    ```bash
      terraform plan
      terraform --auto-approve
    ```
    <img src="" width=800/>
    
### Creating EKS Cluster
1. Create the EKS-cluster.tf file using the EKS cluster module
   [Terraform EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
   
2. Add the provision instructions to the eks-cluster.tf file
   ```bash   
      module "eks" {
        source  = "terraform-aws-modules/eks/aws"
        version = "20.37.2" 
      }   
   ```    
3. Add the cluster name and version in the module.
   ```bash
     #Use the same name used in the VPC section  tags.
     cluster_name    = "myapp-eks-cluster"
     #K8 version
     cluster_version = "1.33"
   ```
 4. Set the subnet IDs, used to deploy the worker nodes and retrieve the VPC ID to connect to this cluster
    ```bash

       #Calling attribute from the VPC module
       #module.<name of the module>.<name of the output-attribute>
       #Workload uses a private subnet as we do not want to expose this information to the public.
       vpc_id     = module.myapp-vpc.vpc_id
       subnet_ids = module.myapp-vpc.private_subnets
    ```
5. Set tags for reference; these are not required as the VPC tags.
   ```bash
     tags = {
         environment = "development"
         application = "myapp"
     }
   ```
6. Configure the worker nodes, using the node groups

   ```bash      
     #Worker nodes: Creating Node Groups. We can define multiple node gropus inside this attribute; each group can have its name and characteristics.
     eks_managed_node_groups = {
         dev = {
             instance_types = ["t2.small"]
             min_size     = 1
             max_size     = 3
             desired_size = 3
         }
     }
     enable_cluster_creator_admin_permissions = true

   ```
7. Apply the modules
   ```bash
     terraform init
   ```
8. Apply configuration
   ```bash
     terraform --auto-approve
   ```
9. Verify configuration on AWS
    

### Accessing EKS Cluster using kubectl
1. Use the AWS EKS command, which updates the kubeconfig file, so it has the correct certificate and token to access the resources.
  ```bash
    aws eks update-kubeconfig --name myapp-eks-cluster --region us-east-2
  ```
    <details><summary><strong>Pre-Requisites</strong></summary>
         AWS CLI installed, kubectl installed, aws-iam-authenticator installed
    </details>
2. If you do kubectl get nodes, it times out as we must configure "public access to our cluster " to be able to reach the cluster from kubectl
   ```bash
     #Makes the k8 publicly accessible from external clients
     cluster_endpoint_public_access = true
   ```
3. Plan and Apply changes
   ```bash
     terraform plan
     terraform apply --auto-approve
   ```
4. Apply a simple nginx deployment
   ```bash
     kubectl apply -f nginx-config.yaml
   ```
5. Check pods
   ```bash
     kubectl get pod -w
   ```
7. Verify services
   ```bash
     kubectl get service
   ```
   
   
