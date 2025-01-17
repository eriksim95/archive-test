module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernets_version

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = concat(var.private_subnet_ids)

  enable_irsa = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    snapshot-controller = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }


  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"

    create_iam_role          = true
    iam_role_use_name_prefix = true

    use_name_prefix = true
    release_version = var.kubernetes_nodes_default_release_version

    iam_role_additional_policies = {
      AmazonSSMFullAccess = "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
      CloudWatchFullAccess = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    }

    pre_bootstrap_user_data = <<-EOT
    #!/bin/bash
    sudo mkdir /tmp/ssm
    cd /tmp/ssm
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo systemctl status amazon-ssm-agent
    EOT

    block_device_mappings = {
      root = {
        device_name = "/prod/xvda"
        ebs = {
          volume_size = 20
          volume_type = "gp3"
        }
      }
    }

    tags = {
      "k8s.io/cluster-autoscaler/enabled"                                         = "true"
      "k8s.io/cluster-autoscaler/${var.cluster_name}"                             = "owned"
      "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"       = "20Gi"
    }
  }

  node_security_group_additional_rules = {
    ingress_vpc = {
      description = "VPC access"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr_block]
    }
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  tags = var.tags
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}

# Required to get token for authorization on EKS
data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}
