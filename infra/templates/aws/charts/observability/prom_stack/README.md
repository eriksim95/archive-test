## Commands

To get the password for Grafana dashboard admin run:
```bash
kubectl get secret --namespace monitoring kube-prom-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
``