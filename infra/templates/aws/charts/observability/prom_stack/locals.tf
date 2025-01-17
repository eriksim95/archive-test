locals {
  base_values = templatefile("${path.module}/values.yaml", {
    prometheus_server_volume_size        = var.prometheus_server_volume_size
    prometheus_alert_manager_volume_size = var.prometheus_alert_manager_volume_size
    release_name                         = var.name
    ingress_enabled                      = var.ingress_enabled
    ingress_group_name                   = var.ingress_group_name
  })
}
