module "iam_assumable_role_cert_manager" {
  source = "github.com/ministryofjustice/ap-terraform-iam-roles//eks-role?ref=v1.4.2"
  depends_on = [
    module.eks
  ]
  role_name_prefix         = "CertManager"
  role_description         = "cert-manager role for cluster ${module.eks.cluster_id}"
  role_policy_arns         = [aws_iam_policy.cert_manager.arn]
  provider_url             = module.eks.cluster_oidc_issuer_url
  cluster_service_accounts = ["cert-manager:cert-manager"]
  tags = {
    cluster = var.cluster_name
  }
}

resource "aws_iam_policy" "cert_manager" {
  depends_on = [
    module.eks
  ]
  name_prefix = "CertManager"
  description = "cert-manager policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.cert_manager.json
  tags = {
    cluster = var.cluster_name
  }
}

data "aws_iam_policy_document" "cert_manager" {
  statement {
    sid    = "certManagerGetChange"
    effect = "Allow"

    actions = [
      "route53:GetChange",
    ]

    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    sid    = "certManagerResourceRecordSets"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = [var.route53_zone_arn]
  }
}
