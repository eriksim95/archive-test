resource "helm_release" "mongodb_cluster" {
  count      = var.mongodb_cluster_enabled ? 1 : 0
  name       = var.mongodb_cluster_release_name
  namespace  = var.mongodb_cluster_namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  version    = var.mongodb_cluster_chart_version
  create_namespace = true

  values = [
    file("${path.module}/values/mongodb-cluster-values.yaml"),
    var.mongodb_cluster_values_override
  ]
}