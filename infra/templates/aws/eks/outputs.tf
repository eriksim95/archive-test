output "eks_cluster_name" {
  description = "Name of EKS K8S cluster"
  value       = module.eks.cluster_name
}

output "eks_region" {
  description = "Region where the cluster deployed"
  value       = data.aws_region.current.name
}

output "eks_endpoint" {
  description = "Endpoint of EKS K8S cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_certificate" {
  description = "Certificate of EKS K8S cluster (base64)"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_token" {
  description = "Authorization token for EKS K8S cluster"
  value       = data.aws_eks_cluster_auth.eks.token
  sensitive   = true
}

output "eks_oidc_provider" {
  description = "EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "eks_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "vpc_id" {
  description = "VPC ID, where the cluster was deployed"
  value       = var.vpc_id
}
