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
2. Extract all outputs to outputs.tf file. This file contains all the outputs of the main project.
3. Create a new modules folder.
4. Create two new subfolders: subnet and webserver subfolders.
5. Create within each subfolder the main.tf, providers.tf, variables.tf files.
6. Open the subnet/main.tf file and copy and paste the subnet, internet gateway, and default routing table from the previous demo.
7. Add the variables used in the subnet/main.tf file in the subnet/variables.tf file and replace hardcoded values into variables.
8. 
