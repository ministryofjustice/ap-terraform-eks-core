<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.18.0 |
| <a name="module_iam_assumable_role_cert_manager"></a> [iam\_assumable\_role\_cert\_manager](#module\_iam\_assumable\_role\_cert\_manager) | github.com/ministryofjustice/ap-terraform-iam-roles//eks-role | v1.4.0 |
| <a name="module_iam_assumable_role_cluster_autoscaler"></a> [iam\_assumable\_role\_cluster\_autoscaler](#module\_iam\_assumable\_role\_cluster\_autoscaler) | github.com/ministryofjustice/ap-terraform-iam-roles//eks-role | v1.4.0 |
| <a name="module_iam_assumable_role_ebs_csi_driver"></a> [iam\_assumable\_role\_ebs\_csi\_driver](#module\_iam\_assumable\_role\_ebs\_csi\_driver) | github.com/ministryofjustice/ap-terraform-iam-roles//eks-role | v1.4.0 |
| <a name="module_iam_assumable_role_external_dns"></a> [iam\_assumable\_role\_external\_dns](#module\_iam\_assumable\_role\_external\_dns) | github.com/ministryofjustice/ap-terraform-iam-roles//eks-role | v1.4.0 |
| <a name="module_iam_assumable_role_external_secrets"></a> [iam\_assumable\_role\_external\_secrets](#module\_iam\_assumable\_role\_external\_secrets) | github.com/ministryofjustice/ap-terraform-iam-roles//eks-role | v1.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_identity_provider_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_iam_policy.cert_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.eks_worker_cloudwatch_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cert_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_coredns_version"></a> [cluster\_coredns\_version](#input\_cluster\_coredns\_version) | Version of the CoreDNS add on | `string` | n/a | yes |
| <a name="input_cluster_ebs_csi_version"></a> [cluster\_ebs\_csi\_version](#input\_cluster\_ebs\_csi\_version) | Version of the EBS CSI add on | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The K8S version of the EKS control plane to provision | `string` | n/a | yes |
| <a name="input_cluster_node_group_version"></a> [cluster\_node\_group\_version](#input\_cluster\_node\_group\_version) | The K8S version of the EKS node group to provision | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The K8S version of the EKS control plane to provision | `string` | n/a | yes |
| <a name="input_cluster_vpc_cni_version"></a> [cluster\_vpc\_cni\_version](#input\_cluster\_vpc\_cni\_version) | Version of the VPC CNI add on | `string` | n/a | yes |
| <a name="input_core_infra_nodegroup_desired_capacity"></a> [core\_infra\_nodegroup\_desired\_capacity](#input\_core\_infra\_nodegroup\_desired\_capacity) | The desired capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_core_infra_nodegroup_instance_types"></a> [core\_infra\_nodegroup\_instance\_types](#input\_core\_infra\_nodegroup\_instance\_types) | EC2 instance types to be used for the core infra EKS nodegroup | `string` | n/a | yes |
| <a name="input_core_infra_nodegroup_max_capacity"></a> [core\_infra\_nodegroup\_max\_capacity](#input\_core\_infra\_nodegroup\_max\_capacity) | The maximum capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_core_infra_nodegroup_min_capacity"></a> [core\_infra\_nodegroup\_min\_capacity](#input\_core\_infra\_nodegroup\_min\_capacity) | The minimum capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | value | `string` | `"60m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | value | `string` | `"60m"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The desired capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_main_nodegroup_desired_capacity"></a> [main\_nodegroup\_desired\_capacity](#input\_main\_nodegroup\_desired\_capacity) | The desired capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_main_nodegroup_instance_types"></a> [main\_nodegroup\_instance\_types](#input\_main\_nodegroup\_instance\_types) | EC2 instance types to be used for the main EKS nodegroup | `string` | n/a | yes |
| <a name="input_main_nodegroup_max_capacity"></a> [main\_nodegroup\_max\_capacity](#input\_main\_nodegroup\_max\_capacity) | The maximum capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_main_nodegroup_min_capacity"></a> [main\_nodegroup\_min\_capacity](#input\_main\_nodegroup\_min\_capacity) | The minimum capacity for the EKS node group | `number` | n/a | yes |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Organisation the EKS cluster should trust | `string` | n/a | yes |
| <a name="input_route53_zone_arn"></a> [route53\_zone\_arn](#input\_route53\_zone\_arn) | The route53 zone ID for the cluster's domain | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of private subnet address ranges in CIDR format | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to create the cluster in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL of the OIDC issuer created by the cluster |
| <a name="output_cluster_role_arns"></a> [cluster\_role\_arns](#output\_cluster\_role\_arns) | ARNS of the roles created to support core K8S components |
<!-- END_TF_DOCS -->
