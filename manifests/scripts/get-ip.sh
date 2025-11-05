#!/bin/bash

echo "Getting frontend public IP..."
kubectl get service frontend-service -n hmi-yolo -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""