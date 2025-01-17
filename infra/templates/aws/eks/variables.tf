variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type    = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "environment" {
  type    = string
  default = " temp"
}

variable "cluster_name" {
  type    = string
  default = "temp"
}

variable "kubernets_version" {
  type    = string
  default = "1.24"
}

variable "kubernetes_nodes_default_release_version" {
  type    = string
  default = "1.24"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "on_demand_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "spot_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "stack_name" {
  type = string
  default = ""

  validation {
    condition     = length(var.stack_name) < 12
    error_message = "Variable must contain less than 12 charaters."
  }
}

variable "iam_role_name" {
  type = string
  default = "test-eks" 
}


variable "eks_managed_node_groups" {
  type    = any
}