resource "helm_release" "prom_stack" {
  count            = var.enabled ? 1 : 0
  name             = var.name
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  create_namespace = var.namespace == "kube-system" ? false : true
  version          = var.chart_version
  namespace        = var.namespace
  values           = [local.base_values]

  dynamic "set" {
    for_each = var.extra_values
    content {
      name  = set.key
      value = set.value
    }
  } 
}