#!/bin/bash

# Creating Service account for Kubernetes
kubectl create namespace webapps

# Apply Kubernetes configurations
kubectl apply -f /home/ubuntu/sa.yaml
exit_status_print $?

kubectl apply -f /home/ubuntu/rol.yaml
exit_status_print $?

kubectl apply -f /home/ubuntu/bind.yaml
exit_status_print $?

kubectl apply -f /home/ubuntu/sec.yaml -n webapps
exit_status_print $?

# Get the Key
kubectl -n webapps describe secret mysecretname
