# scripts/deploy.sh
#!/bin/bash
set -e

# Deploy Helm chart
helm upgrade --install stylestack helm-charts/stylestack \
  --namespace stylestack --create-namespace