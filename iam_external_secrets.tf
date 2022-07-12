data "aws_iam_policy_document" "external_secrets" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    effect    = "Allow"
    resources = ["arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:*"]
    sid       = "externalSecrets"
  }
}

module "iam_assumable_role_external_secrets" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "3.8.0"
  depends_on = [
    module.eks
  ]

  create_role                   = true
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets:external-secrets"]
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_name_prefix              = var.cluster_name
  role_policy_arns              = [aws_iam_policy.external_secrets.arn]
  tags = {
    usage = "external secrets"
  }
}

resource "aws_iam_policy" "external_secrets" {
  depends_on = [
    module.eks
  ]
  description = "external_secrets policy for cluster ${module.eks.cluster_id}"
  name_prefix = var.cluster_name
  policy      = data.aws_iam_policy_document.external_secrets.json
  tags = {
    usage = "external secrets"
  }
}
