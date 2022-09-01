module "iam_assumable_role_external_dns" {
  source = "git@github.com:ministryofjustice/ap-terraform-iam-roles.git//eks-role?ref=v1.3.0"
  depends_on = [
    module.eks
  ]
  create_role                   = true
  role_name_prefix              = "ExternalDNS"
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-dns:external-dns"]
  tags = {
    cluster = var.cluster_name
  }
}

resource "aws_iam_policy" "external_dns" {
  depends_on = [
    module.eks
  ]
  name_prefix = "ExternalDNS"
  description = "external dns policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.external_dns.json
  tags = {
    cluster = var.cluster_name
  }
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "externalDNSListHostedZones"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "externalDNSResourceRecordSets"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = [var.route53_zone_arn]
  }
}
