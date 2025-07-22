#AWS-EKS module
#minimum required configuration to bring up the cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2"

  cluster_name    = "myapp-eks-cluster"
  #K8 version
  cluster_version = "1.33"
  
  #Calling attribute from a module
  #module.<name of the module>.<name of the output-attribute>
  vpc_id     = module.myapp-vpc.vpc_id
  subnet_ids = module.myapp-vpc.private_subnets
  
  tags = {
    environment = "development"
    application = "myapp"
  }

  #Worker nodes: Creating Managed Node Groups
  eks_managed_node_groups = {
    dev = {
        
      instance_types = ["t2.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }

  enable_cluster_creator_admin_permissions = true

  #Makes the k8 publicly accessible from external clients
  cluster_endpoint_public_access = true

}
