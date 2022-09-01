module "iam_assumable_role_cluster_autoscaler" {
  source  = "git@github.com:ministryofjustice/ap-terraform-iam-roles.git//eks-role?ref=v1.3.0"
  depends_on = [
    module.eks
  ]
  create_role                   = true
  role_name_prefix              = "ClusterAutoscaler"
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
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
