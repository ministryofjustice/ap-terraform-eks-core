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
  map_roles                   = {}
  subnets                     = module.vpc.private_subnets
  cluster_name                = local.cluster_name
  cluster_version             = ""
  cluster_node_group_version  = ""
  cluster_vpc_cni_version     = ""
  cluster_coredns_version     = ""
  cluster_kube_proxy_version  = ""
  cluster_node_instance_types = ""
  desired_capacity            = ""
  disk_size                   = ""
  max_capacity                = ""
  min_capacity                = ""
  vpc_id                      = ""

  # You will likely have to use a fake ARN here
  route53_zone_arn            = ""

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
