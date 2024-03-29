# tfsec:ignore:aws-eks-no-public-cluster-access
# tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
# tfsec:ignore:aws-vpc-no-public-egress-sgr
# tfsec:ignore:aws-vpc-no-public-egress-sgr
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]
  cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access = true
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = true
  map_roles                       = var.map_roles
  node_groups = {
    main_node_pool = {
      instance_types                       = [var.main_nodegroup_instance_types]
      min_capacity                         = var.main_nodegroup_min_capacity
      max_capacity                         = var.main_nodegroup_max_capacity
      desired_capacity                     = var.main_nodegroup_desired_capacity
      create_launch_template               = true
      metadata_http_endpoint               = "enabled"
      metadata_http_put_response_hop_limit = 1
      metadata_http_tokens                 = "required"
      name_prefix                          = "${var.cluster_name}-main"
    }
    core_infra_node_pool = {
      instance_types                       = [var.core_infra_nodegroup_instance_types]
      min_capacity                         = var.core_infra_nodegroup_min_capacity
      max_capacity                         = var.core_infra_nodegroup_max_capacity
      desired_capacity                     = var.core_infra_nodegroup_desired_capacity
      create_launch_template               = true
      metadata_http_endpoint               = "enabled"
      metadata_http_put_response_hop_limit = 1
      metadata_http_tokens                 = "required"
      name_prefix                          = "${var.cluster_name}-core-infra"
      k8s_labels = {
        type = "core-infra"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "core-infra"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }
  node_groups_defaults = {
    ami_type  = "AL2_x86_64" # Amazon Linux 2
    disk_size = var.disk_size
    version   = var.cluster_node_group_version
  }
  subnets                     = var.subnets
  vpc_id                      = var.vpc_id
  workers_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

}

# allow cloudwatch agent on worker nodes
resource "aws_iam_role_policy_attachment" "eks_worker_cloudwatch_agent" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.eks.worker_iam_role_name
}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
}
