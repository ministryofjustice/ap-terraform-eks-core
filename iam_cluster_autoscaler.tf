module "iam_assumable_role_cluster_autoscaler" {
  source = "github.com/ministryofjustice/ap-terraform-iam-roles//eks-role?ref=v1.4.0"
  depends_on = [
    module.eks
  ]
  role_name_prefix         = "ClusterAutoscaler"
  role_description         = "EKS cluster-autoscaler role for cluster ${module.eks.cluster_id}"
  role_policy_arns         = [aws_iam_policy.cluster_autoscaler.arn]
  provider_url             = module.eks.cluster_oidc_issuer_url
  cluster_service_accounts = ["kube-system:cluster-autoscaler"]
  tags = {
    cluster = var.cluster_name
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  depends_on = [
    module.eks
  ]
  name_prefix = "ClusterAutoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
  tags = {
    cluster = var.cluster_name
  }
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "clusterAutoscalerAll"
  }
  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]
    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
    effect    = "Allow"
    resources = ["*"]
    sid       = "clusterAutoscalerOwn"
  }
}
