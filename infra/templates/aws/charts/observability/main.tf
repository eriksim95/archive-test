module "prom_stack" {
  source                               = "./prom_stack"
  enabled                              = var.prom_stack_enabled
  namespace                            = var.prom_stack_namespace
  serviceaccount                       = var.prom_stack_serviceaccount
  cluster_name                         = var.cluster_name
  prometheus_server_volume_size        = var.prom_stack_prometheus_server_volume_size
  prometheus_alert_manager_volume_size = var.prom_stack_prometheus_alert_manager_volume_size
  ingress_enabled                      = var.prom_stack_ingress_enabled
}