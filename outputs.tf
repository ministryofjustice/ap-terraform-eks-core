output "cluster_id" {
  description = "The ID of the cluster"
  value       = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL of the OIDC issuer created by the cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_role_arns" {
  description = "ARNS of the roles created to support core K8S components"
  value = {
    external_dns     = module.iam_assumable_role_external_dns.this_iam_role_arn
    external_secrets = module.iam_assumable_role_external_secrets.this_iam_role_arn
    autoscaler       = module.iam_assumable_role_cluster_autoscaler.this_iam_role_arn
    cert_manager     = module.iam_assumable_role_cert_manager.this_iam_role_arn
  }
}