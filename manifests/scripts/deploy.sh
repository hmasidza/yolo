#!/bin/bash

echo "1. Creating namespace..."
kubectl apply -f namespace.yaml

echo "2. Deploying MongoDB..."
kubectl apply -f mongodb-statefulset.yaml

echo "3. Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod/mongodb-0 -n hmi-yolo --timeout=120s

echo "4. Deploying Backend..."
kubectl apply -f backend-deployment.yaml

echo "5. Deploying Frontend..."
kubectl apply -f frontend-deployment.yaml

echo "=== Deployment Complete ==="
echo ""
echo "6. Checking resources:"
kubectl get all -n hmi-yolo

echo ""
echo "7. To get the public IP, run:"
echo "   kubectl get service frontend-service -n hmi-yolo"