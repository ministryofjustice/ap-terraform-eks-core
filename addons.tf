resource "aws_eks_addon" "coredns" {
  depends_on = [
    module.eks
  ]
  addon_name        = "coredns"
  addon_version     = var.cluster_coredns_version
  cluster_name      = module.eks.cluster_id
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  depends_on = [
    module.eks
  ]
  addon_name        = "kube-proxy"
  addon_version     = var.cluster_kube_proxy_version
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
