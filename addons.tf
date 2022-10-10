resource "aws_eks_addon" "coredns" {
  depends_on = [
    module.eks
  ]
  addon_name        = "coredns"
  addon_version     = var.cluster_coredns_version
  cluster_name      = module.eks.cluster_id
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni" {
  depends_on = [
    module.eks
  ]
  addon_name        = "vpc-cni"
  addon_version     = var.cluster_vpc_cni_version
  cluster_name      = module.eks.cluster_id
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "ebs_csi" {
  depends_on = [
    module.eks
  ]
  addon_name        = "ebs-csi"
  addon_version     = var.cluster_ebs_csi_version
  cluster_name      = module.eks.cluster_id
  resolve_conflicts = "OVERWRITE"
}
