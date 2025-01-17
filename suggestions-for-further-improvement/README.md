# Future Infrastructure Improvements

This document outlines ideas and recommendations for enhancing the current EKS-based platform. The goal is to address multi-tenancy, minimize overhead for rolling out new products, enable automated DNS/Secrets management, ensure observability, and handle spikes through smooth auto-scaling. In addition, it highlights a CI/CD approach that automatically builds, tags, and deploys images via GitOps (Argo CD).

---

## Table of Contents

1. [Separate Repositories and GitOps with Argo CD](#1-separate-repositories-and-gitops-with-argo-cd)  
2. [Multi-Tenancy and Isolation](#2-multi-tenancy-and-isolation)  
3. [Automated CI/CD Pipeline](#3-automated-cicd-pipeline)  
4. [Auto-Scaling with Karpenter](#4-auto-scaling-with-karpenter)  
5. [Automated DNS and Certificates (ExternalDNS)](#5-automated-dns-and-certificates-externaldns)  
6. [External Secrets Management](#6-external-secrets-management)  
7. [Additional Observability Options](#7-additional-observability-options)  
8. [Conclusion](#8-conclusion)

---

## 1. Separate Repositories and GitOps with Argo CD

### Reason for Multiple Repos

- **Modularity**: Keep infrastructure code, Helm charts, and application code in separate repositories for clarity and reduced coupling.  
- **Security**: Control who can access each repository; platform engineers manage infra repos, product teams manage their own app repos.  
- **Scalability**: Each repo follows its own lifecycle and permissions as the organization grows.

### Suggested Repo Structure

1. **Infrastructure Repo**: Terraform/Terragrunt for AWS resources (EKS, VPC, RDS, etc.) and system-level Helm releases.  
2. **Cluster Configuration Repo**: YAML/Helm charts for shared add-ons (e.g., Ingress controller, cert-manager). Managed by Argo CD to ensure the desired state is always applied.  
3. **Application Charts Repo**: Each product’s Helm chart or a shared “helm-charts” repo.  
4. **Argo CD**: Watches these repos; whenever changes are pushed, it reconciles them automatically.
### High-Level Steps

- Deploy Argo CD into the cluster in a dedicated namespace.  
- Configure it to monitor relevant Git repositories for infrastructure and application changes.  
- Enable automated sync policies so Argo CD keeps the cluster in sync without manual intervention  (Could be synced manually for prod environment for safety purposes by testing in 
  dev,staging environments).


---

## 2. Multi-Tenancy and Isolation

### Namespaced Approach

- Host multiple products in one EKS cluster, but assign each product a separate namespace. (Based on the company requirements each product/project can have it's own cluster)
- Apply RBAC so teams have admin rights only in “their” namespace.

### Network Policies

- Enforce namespace isolation so product A cannot directly communicate with product B unless explicitly allowed.

### Resource Quotas

- Optionally limit CPU/Memory usage to avoid one team saturating cluster resources.

#### Benefits

- **Isolation**: Teams only see/manage their own workloads.  
- **Security**: Limits risk of accidental cross-team interference.  
- **Simplicity**: One cluster to maintain, but logically separated workloads.

---

## 3. Automated CI/CD Pipeline

### Workflow Overview

1. **Code Commit**: A developer pushes code to the application’s repo.  
2. **Build & Test**: CI pipeline (e.g. GitHub Actions) executes tests, builds the Docker image.  
3. **Push to ECR**: The newly built Docker image is tagged and uploaded to Amazon ECR.  
4. **GitOps Update**: Application’s Helm chart values (e.g., `image.tag`) are updated in a repo Argo CD is watching.  
5. **Argo CD Deployment**: Argo CD detects the new image tag and deploys it to the cluster automatically. (again we can leave for production environment to apply sync operations manually. If we want to keep everything to be autoamatically deployed another approach would be to use multibranch pipeline strategy, so before running the prod pipeline the application is already tested in the other environments).

### Why Automated?

- Reduces manual steps and potential errors.  
- Ensures consistency and traceability (each change is tracked in Git).  
- Speeds up delivery when teams want to roll out new versions quickly.

---

## 4. Auto-Scaling with Karpenter

### Why Karpenter?

- Dynamically provisions right-sized nodes when pods are pending, optimizing cost and performance.  
- More flexible than older solutions (e.g., Cluster Autoscaler), with faster scaling decisions.

## 5. Automated DNS and Certificates (ExternalDNS)

### ExternalDNS

- Automatically creates/updates DNS records (e.g., in AWS Route53) whenever new Ingress resources appear.  
- Reduces overhead of manually managing DNS entries for each service.

### cert-manager

- Issues and renews SSL/TLS certificates (e.g. Let’s Encrypt).  
- Eliminates the need for manual certificate provisioning.  
- Integrates with Kubernetes Ingress to request certificates automatically.

---

## 6. External Secrets Management

### Why External Secrets?

- Storing secrets in AWS Secrets Manager or another provider is safer than storing them directly in Kubernetes.  
- Automates synchronization of secret changes to Kubernetes (This is useful when the application environment variables contain sensitive information).

### Operator Approach

- Deploy a Kubernetes operator (e.g., External Secrets Operator) to manage secret fetching.  
- Define `ExternalSecret` resources referencing your external secret store.  
- The operator updates standard Kubernetes `Secret` objects automatically.

---

## 7. Additional Observability Options

### Logging

- Current setup uses Elasticsearch/Kibana/Filebeat. Alternatively, consider Loki for logs if you want a more lightweight solution alongside Prometheus.

### Dashboards & Alerts

- Standardize alert rules for CPU/memory usage and custom application metrics. (Additional monitoring dashboards can be created based on the needs). 
- Provide teams a self-service approach to create or modify alert rules (The alert rules can be defined after discussing with the developers when the application should be in an alerting status).

---

## 8. Conclusion

By implementing these improvements, you will achieve:

- **Stronger Isolation**: Namespaced multi-tenancy, RBAC, and network policies ensure each product is secure and self-contained.  
- **Streamlined Rollouts**: A GitOps-based workflow (Argo CD) ensures changes are automatically deployed with minimal effort.  
- **High Availability**: Auto-scaling tools like Karpenter let you handle traffic spikes effectively.  
- **Automated DNS, Certs, & Secrets**: Tools like ExternalDNS, cert-manager, and External Secrets Operator reduce manual overhead.  
- **Enhanced Observability**: The monitoring/logging stack gives each product team insights into their services.

These enhancements form a self-service platform that supports new product rollouts, smooth scaling, and easy troubleshooting—meeting organizational needs now and into the future.

---
P.S. Easier said than done, but I hope this document gives you high overview of how the infrastructure can be improved. It's always nice to know what should be done, however it's even better to get the things done (Not in three hours, obviously).   :) 

---
Sincerely,

Erik