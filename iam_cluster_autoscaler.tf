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

module "iam_assumable_role_cluster_autoscaler" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "3.8.0"
  depends_on = [
    module.eks
  ]

  create_role                   = true
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_name_prefix              = "${var.cluster_name}-autoscaler"
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
}

resource "aws_iam_policy" "cluster_autoscaler" {
  depends_on = [
    module.eks
  ]
  description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
  name_prefix = "${var.cluster_name}-autoscaler"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}
