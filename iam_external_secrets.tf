module "iam_assumable_role_external_secrets" {
  source  = "git@github.com:ministryofjustice/ap-terraform-iam-roles.git//eks-role?ref=v1.3.0"
  depends_on = [
    module.eks
  ]
  create_role                   = true
  role_name_prefix              = "ExternalSecrets"
  role_policy_arns              = [aws_iam_policy.external_secrets.arn]
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets:external-secrets"]
  tags = {
    cluster = ${var.cluster_name}
  }
}

resource "aws_iam_policy" "external_secrets" {
  depends_on = [
    module.eks
  ]
  name_prefix = "ExternalSecrets"
  description = "external_secrets policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.external_secrets.json
  tags = {
    cluster = ${var.cluster_name}
  }
}

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
