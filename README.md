# Project Setup and Deployment

This project includes the deployment of an EKS cluster, system charts, observability tools, Elasticsearch, MongoDB, and a custom application using Terraform, Helm, and Docker.

## Prerequisites

- Terraform
- Terragrunt
- Docker
- AWS CLI
- Helm

## AWS CLI Configuration
Before running any terragrunt commands, ensure that your `AWS CLI` is configured properly. Run the following command to configure your AWS user:

```
aws configure
```
You will need to provide your AWS Access Key ID, Secret Access Key, default region, and output format.

## Infrastructure Setup

### Quick Start

You can deploy the entire infrastructure in one step by navigating to the main `infra/terragrunt/prod/aws/prod-backend/us-east-1` directory and running:

```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1
terragrunt run-all apply
```
## Detailed Steps

## Step 1: EKS Cluster

To install the EKS cluster, navigate to the following directory and apply the configuration:(note that for testing purposes I used spot instances, but in real prod environment this is not the recommended approach)

```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/infra-01/app_cluster/010_eks
```
```
terragrunt apply
```

## Step 2: System Charts

The system charts include `cluster_autoscaler`, `ebs_csi`, and `metrics_server`. To install these charts, navigate to the following directory:
```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/infra-01/app_cluster/020_system_charts
```
```
terragrunt apply
```

## Step 3: Observability (Prometheus and Grafana)

Prometheus and Grafana are deployed using the `prom_stack` module. To install the observability stack, go to the following directory:
```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/infra-01/app_cluster/030_observability
```
```
terragrunt apply
```

## Step 4: Elasticsearch and Filebeat

To deploy Elasticsearch, Filebeat, and Kibana, navigate to the following directory:

```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/infra-01/app_cluster/040_elasticsearch
```
```
terragrunt apply
```

- Kibana will be exposed via a ClusterIP service. You can access it using port-forwarding:

  ```
  kubectl port-forward svc/elasticsearch-kibana -n logging 5601:5601
  ```
  After port-forwarding, you can access the Kibana dashboard at http://localhost:5601.

- Viewing Logs in Kibana: Once inside Kibana, follow these steps to view the application logs:

  1. Go to the Discover tab in the Kibana dashboard.
  2. Select the index pattern that matches your log data (e.g., filebeat-*).
  3. Apply filters as needed to view the logs from the application.

## Step 5: MongoDB  

The application uses MongoDB as a database. To deploy MongoDB, run the following command:

```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/infra-01/app_cluster/050_mongodb
```
```
terragrunt apply
```

## Step 6: ECR Repository

Before deploying the application, you need to create an ECR repository to store the Docker images. Run the following command:
```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1/ecr
```
```
terragrunt apply
```

## Docker Image Management

The application is containerized using Docker. Follow these steps to build, tag, and push the Docker image to ECR:

### 1. Build the Docker image:

 If you are not using macOS, build the Docker image using the following command in root of the repository:

```
docker build -t <your-image-name> .
```

If you are using macOS, use the following command to build the image with buildx to ensure compatibility with the Linux environment:

```
docker buildx build --platform linux/amd64 -t <your-image-name> .
```

### 2. Tag the Docker image:

```
docker tag <your-image-name>:latest <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
```

### 3. Push the Docker image to ECR:

```
docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
```

### 4. Update the Helm chart:

After the Docker image is pushed to ECR, update the `image.repository` and `image.tag` fields in the Helm chart values to point to the new image in ECR.

## Application Deployment

The application is defined as a Helm chart located in the charts/test_app directory. To deploy the application:

### 1. Install the application via Helm:


```
cd charts/test_app
```
```
helm install <release-name> . -n <namespace>
```

## Accessing Services

- Grafana is exposed via a LoadBalancer service. You can access it directly via the external IP provided by the LoadBalancer. Grafana is deployed in the `monitoring` namespace. To find the external IP, use the following command:

  ```
  kubectl get svc -n monitoring
  ```
  Copy the EXTERNAL-IP and access Grafana via your browser at:

  ```
  http://<EXTERNAL-IP>
  ```

- Kibana can be accessed via port-forwarding:

  ```
  kubectl port-forward svc/elasticsearch-kibana -n logging 5601:5601
  ```
  You can now access the Kibana dashboard at http://localhost:5601.


## Application Health Check

The application is configured to expose a ping endpoint that can be used to check if it's running. The application is exposed via a LoadBalancer service.

To verify if the application is working, you can `curl` the load balancer address:

  ```
  curl http://<app-load-balancer-address>/ping
  ```
  You should receive a response indicating the application is up and running.

## Clean-Up
Once you are done, you can destroy the entire infrastructure by running:

```
cd infra/terragrunt/prod/aws/prod-backend/us-east-1
terragrunt run-all destroy
```

## Conclusion
This project utilizes Terraform, Terragrunt, Helm, and Docker to deploy an EKS-based infrastructure with observability, logging, and monitoring capabilities. The application is containerized, and the entire setup is managed via Terraform modules. The Grafana dashboard is exposed via a LoadBalancer, while Kibana requires port-forwarding for access. The application health can be checked by pinging the load balancer address.
