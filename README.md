# TERRAFORM & AWS EKS
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
   
2. Clean up the previous configuration
   
3. Create a new branch
   ```bash
     git checkout -b features/eks
   ```
  
4. Create VPC.tf file, where we are going to use the VPC module available here:  
   🔗[Terraform VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/2%20create%20vpctf.png" width=800 />
   
6. Add the AWS provider and specify the region to use in the project. In the VPC.tf file:
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
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/1%20copy%20th%20einit%20instrctions%20to%20use%20the%20vpc%20module.png" width=800/>
   
7. Configure the name of the VPC and the CIDR block.
   ```bash
      name = "myapp-vpc"
      cidr = var.vpc_cidr_block 
   ```
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/3%20b%20name%20and%20network.PNG" width=800/>
   
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
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/6%20variables%20valeus.png" width=800/>
    
10. Add private and public subnets in the vpc.tf
    ```bash
      private_subnets = var.private_subnet_cidr_blocks
      public_subnets = var.public_subnet_cidr_blocks
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/3c%20subnets.PNG" width=800/>
    
11.  Query available availability zones (AZs) to use them dynamically. Use the aws_availability_zones data block outside of the module section
     ```bash
        data "aws_availability_zones" "azs" {}
     ```
     <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/3e.PNG" width=800/>

12. Pass available AZs to the module, inside the module block in the vpc.tf:
    ```bash
      azs = data.aws_availability_zones.azs.names 
    ```
    <details><summary><strong> Available AZs.</strong></summary> The list of AZs depends on the region defined in the provider block. </details>

    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/3d%20azs.PNG" width=800/>
    
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
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/7%20enable%20dns%20hostnames.png" width=800/>

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
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/8%20ttags%20to%20hel%20ccm%20to%20know%20where%20it%20should%20connect%20to.png" width=800/>
    
17. Initialize Terraform
    ```bash
      terraform init
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/9%20installing%20new%20module.png" width=800 />
    
18. Plan and apply changes
    ```bash
      terraform plan
      terraform --auto-approve
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_12_Terraform_AWS/blob/feature/eks/Img/applied%20eks.png" width=800/>
    
### Creating the EKS Cluster
Follow these steps to create an Amazon EKS cluster using the Terraform AWS EKS module:

1. Create the EKS-cluster.tf file: 🔗[Terraform EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
   
2. Add the  EKS module block in eks-cluster.tf:
   ```bash   
      module "eks" {
        source  = "terraform-aws-modules/eks/aws"
        version = "20.37.2" 
      }   
   ```
   <img src="" width=800/>
   
3. Set the cluster name and Kubernetes version. Use the same cluster na,e as in the VPC tags
   ```bash
     cluster_name    = "myapp-eks-cluster"
     cluster_version = "1.33"
   ```
   <img src="" width=800/>
   
 4. Set the VPC ID and private subnet IDs. Use private subnets to keep the workload internal.
    ```bash
       vpc_id     = module.myapp-vpc.vpc_id
       subnet_ids = module.myapp-vpc.private_subnets
    ```

     <details><summary><strong>Using Output from another Module</strong></summary>
     module.<module_name>.<output_name> is used to reference outputs from another module.</details>

   <img src="" width=800/>
    
5. Add optional reference tags. These tags are not required by EKS but help identify resources:
     ```bash
       tags = {
           environment = "development"
           application = "myapp"
       }
     ```
     <img src="" width=800/>
     
6. Configure managed node groups. Define worker nodes using eks_managed_node_groups. You can declare multiple groups with different configurations:

   ```bash      
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
   <img src="" width=800/>
   
7. Initialize the Terraform configuration
   ```bash
     terraform init
   ```
   
8. Apply the configuration
   ```bash
     terraform --auto-approve
   ```
   
9. Verify the cluster in the AWS Management Console
    <img src="" width=800/>
    <img src="" width=800/>
    <img src="" width=800/>
    

### Accessing EKS Cluster using kubectl
Follow these steps to configure access to your Amazon EKS cluster using kubectl.

1. Update your kubeconfig file. Use the AWS CLI to update the kubeconfig file with the correct credentials and cluster endpoint: 
    ```bash
      aws eks update-kubeconfig --name myapp-eks-cluster --region us-east-2
    ```
    <details><summary><strong>Pre-Requisites</strong></summary> AWS CLI installed, kubectl installed, aws-iam-authenticator installed </details>

    <img src="" width=800/>
    
2. Enable public access to the EKS cluster. If kubectl get nodes results in a timeout, you may need to enable public access to the EKS cluster endpoint.
   In your eks-cluster.tf:
   
   ```bash
     cluster_endpoint_public_access = true
   ```
    <details><summary><strong>Access EKS from external clients </strong></summary>
           This setting allows access to the cluster API server from external clients.
    </details>
      
   <img src="" width=800/>
   
4. Plan and apply the configuration
   ```bash
     terraform plan
     terraform apply --auto-approve
   ```
5. Deploy a sample NGINX workload:
   Apply the NGINX deployment configuration:
   ```bash
     kubectl apply -f nginx-config.yaml
   ```
   <img src="" width=800/>
   
6. Verify pods. Use the -w flag to watch pod status changes in real time:
   ```bash
     kubectl get pod -w
   ```
   <img src="" width=800/>
   
7. Verify services
   ```bash
     kubectl get service
   ```
   <img src="" width=800/>
   
   
