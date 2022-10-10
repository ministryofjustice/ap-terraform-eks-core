resource "aws_eks_identity_provider_config" "this" {
  depends_on = [
    module.eks
  ]
  cluster_name = var.cluster_name

  oidc {
    client_id                     = "https://github.com/${var.org_name}"
    identity_provider_config_name = "github-${var.org_name}"
    issuer_url                    = "https://token.actions.githubusercontent.com"
    username_claim                = "repository"
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}
