module "iam_assumable_role_ebs_csi_driver" {
  source = "github.com/ministryofjustice/ap-terraform-iam-roles//eks-role?ref=v1.4.0"
  depends_on = [
    module.eks
  ]
  role_name_prefix         = "EbsCsiDriver"
  role_description         = "ebs_csi_driver role for cluster ${module.eks.cluster_id}"
  role_policy_arns         = [aws_iam_policy.ebs_csi_driver.arn]
  provider_url             = module.eks.cluster_oidc_issuer_url
  cluster_service_accounts = ["kube-system:ebs-csi-controller-sa"]
  tags = {
    cluster = var.cluster_name
  }
}

resource "aws_iam_policy" "ebs_csi_driver" {
  depends_on = [
    module.eks
  ]
  name_prefix = "EbsCsiDriver"
  description = "ebs_csi_driver policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.ebs_csi_driver.json
  tags = {
    cluster = var.cluster_name
  }
}

data "aws_iam_policy_document" "ebs_csi_driver" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume"
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "EbsCsiDriver"
  }
}
