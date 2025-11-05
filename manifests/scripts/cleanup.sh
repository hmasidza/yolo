#!/bin/bash

echo "=== Cleaning up HMI YOLO Application ==="

echo "Deleting frontend..."
kubectl delete -f frontend-deployment.yaml

echo "Deleting backend..."
kubectl delete -f backend-deployment.yaml

echo "Deleting database..."
kubectl delete -f mongodb-statefulset.yaml

echo "Deleting namespace..."
kubectl delete -f namespace.yaml

echo "=== Cleanup Complete ==="