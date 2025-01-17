
module "metrics_server" {
  count          = var.metrics_server_enabled ? 1 : 0
  source         = "./metrics_server"
  namespace      = var.metrics_server_namespace
  serviceaccount = var.metrics_server_serviceaccount
  cluster_name   = var.cluster_name
}

module "ebs_csi_driver" {
  count                 = var.ebs_csi_enabled ? 1 : 0
  source                = "./ebs_csi"
  namespace             = var.ebs_csi_driver_namespace
  serviceaccount        = var.ebs_csi_driver_serviceaccount
  region                = var.region
  cluster_oidc_provider = var.cluster_oidc_provider
}

module "cluster-autoscaler" {
  count                 = var.cluster_autoscaler_enabled ? 1 : 0
  source                = "./cluster_autoscaler"
  enabled               = var.cluster_autoscaler_enabled
  namespace             = var.cluster_autoscaler_namespace
  serviceaccount        = var.cluster_autoscaler_serviceaccount
  region                = var.region
  cluster_name          = var.cluster_name
  cluster_oidc_provider = var.cluster_oidc_provider
  extra_values          = var.cluster_autoscaler_extra_values
}