resource "helm_release" "elasticsearch" {
  count      = var.elasticsearch_enabled ? 1 : 0
  name       = "elasticsearch"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "elasticsearch"
  version    = var.elasticsearch_chart_version

  namespace  = var.elasticsearch_namespace 
  create_namespace = true

  values = [
    file("${path.module}/values/elasticsearch-values.yaml")
  ]  

  # Optionally, set dependencies if necessary
}


# resource "helm_release" "kibana" {
#   count      = var.kibana_enabled ? 1 : 0  
#   name       = "kibana"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "kibana"
#   version    = var.kibana_chart_version

#   namespace  = var.kibana_namespace 
#   create_namespace = false  # Already created with Elasticsearch

#   values = [
#     file("${path.module}/values/kibana-values.yaml")
#   ]  
#   # Optionally, set dependencies if necessary
# }

resource "helm_release" "filebeat" {
  count      = var.filebeat_enabled ? 1 : 0  
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  version    = var.filebeat_chart_version

  namespace  = var.filebeat_namespace  
  create_namespace = false  # Already created with Elasticsearch

  values = [
    file("${path.module}/values/filebeat-values.yaml")
  ]  
  # Optionally, set dependencies if necessary
}
