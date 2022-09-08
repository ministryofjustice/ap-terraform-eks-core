locals {

  cluster_name           = "eks-core-dev-cluster"
  vpc_availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_cidr               = "10.69.0.0/16"
  vpc_private_subnets    = ["10.69.96.0/20", "10.69.112.0/20", "10.69.128.0/20"]
  vpc_public_subnets     = ["10.69.144.0/20", "10.69.160.0/20", "10.69.176.0/20"]

  # Add more locals as required
}

module "eks_cluster" {
  source = "./.."

  # This needs specifiying properly
  map_roles                             = []
  subnets                               = module.vpc.private_subnets
  cluster_name                          = local.cluster_name
  cluster_version                       = "1.21"
  cluster_node_group_version            = "1.21"
  cluster_vpc_cni_version               = "v1.9.0-eksbuild.1"
  cluster_coredns_version               = "v1.8.4-eksbuild.1"
  cluster_kube_proxy_version            = "v1.21.2-eksbuild.2"
  main_nodegroup_instance_types         = "r5.2xlarge"
  core_infra_nodegroup_instance_types   = "r5.4xlarge"
  main_nodegroup_min_capacity           = 3
  main_nodegroup_max_capacity           = 6
  main_nodegroup_desired_capacity       = 3
  core_infra_nodegroup_min_capacity     = 3
  core_infra_nodegroup_max_capacity     = 6
  core_infra_nodegroup_desired_capacity = 3
  disk_size                             = 50
  vpc_id                                = module.vpc.vpc_id

  # You will likely have to use a fake ARN here
  route53_zone_arn = "arn:aws:route53:::hostedzone/Z111XEXAMPLE9"

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  azs                  = local.vpc_availability_zones
  cidr                 = local.vpc_cidr
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  name                 = local.cluster_name
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
  private_subnets = local.vpc_private_subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
  public_subnets     = local.vpc_public_subnets
  single_nat_gateway = false
}
