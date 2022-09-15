variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "subnets" {
  description = "List of private subnet address ranges in CIDR format"
  type        = list(string)
}

variable "cluster_name" {
  description = "The K8S version of the EKS control plane to provision"
  type        = string
}

variable "cluster_version" {
  description = "The K8S version of the EKS control plane to provision"
  type        = string
}

variable "cluster_node_group_version" {
  description = "The K8S version of the EKS node group to provision"
  type        = string
}

variable "cluster_vpc_cni_version" {
  description = "Version of the VPC CNI add on"
  type        = string
}

variable "cluster_coredns_version" {
  description = "Version of the CoreDNS add on"
  type        = string
}

variable "main_nodegroup_instance_types" {
  description = "EC2 instance types to be used for the main EKS nodegroup"
  type        = string
}

variable "core_infra_nodegroup_instance_types" {
  description = "EC2 instance types to be used for the core infra EKS nodegroup"
  type        = string
}

variable "main_nodegroup_min_capacity" {
  description = "The minimum capacity for the EKS node group"
  type        = number
}

variable "main_nodegroup_max_capacity" {
  description = "The maximum capacity for the EKS node group"
  type        = number
}

variable "main_nodegroup_desired_capacity" {
  description = "The desired capacity for the EKS node group"
  type        = number
}

variable "core_infra_nodegroup_min_capacity" {
  description = "The minimum capacity for the EKS node group"
  type        = number
}

variable "core_infra_nodegroup_max_capacity" {
  description = "The maximum capacity for the EKS node group"
  type        = number
}

variable "core_infra_nodegroup_desired_capacity" {
  description = "The desired capacity for the EKS node group"
  type        = number
}

variable "disk_size" {
  description = "The desired capacity for the EKS node group "
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC to create the cluster in"
  type        = string
}

variable "route53_zone_arn" {
  description = "The route53 zone ID for the cluster's domain"
  type        = string
}
