# scripts/build.sh
#!/bin/bash
set -e

# Build Docker images
for service in services/*; do
  if [ -d "$service" ]; then
    service_name=$(basename "$service")
    echo "Building $service_name..."
    docker build -t stylestack/$service_name:latest $service
  fi
done
