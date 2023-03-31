terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.71.0"
    }

    # False positive: the kubernetes provider is used in a sub-module
    # tflint-ignore: terraform_unused_required_providers
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
  required_version = ">= 0.14"
}
