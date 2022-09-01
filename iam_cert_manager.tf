module "iam_assumable_role_cert_manager" {
  source                        = "git@github.com:ministryofjustice/ap-terraform-iam-roles.git//eks-role?ref=v1.3.0"
  depends_on = [
    module.eks
  ]
  create_role                   = true
  role_name_prefix              = "CertManager"
  role_policy_arns              = [aws_iam_policy.cert_manager.arn]
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:cert-manager:cert-manager"]
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
