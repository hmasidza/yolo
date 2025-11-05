#!/bin/bash

echo "=== Application Status ==="

echo ""
echo "1. All Pods:"
kubectl get pods -n hmi-yolo

echo ""
echo "2. All Services:"
kubectl get services -n hmi-yolo

echo ""
echo "3. Database Pod:"
kubectl get pods -n hmi-yolo -l app=mongodb

echo ""
echo "4. Backend Pods:"
kubectl get pods -n hmi-yolo -l app=backend

echo ""
echo "5. Frontend Pods:"
kubectl get pods -n hmi-yolo -l app=frontend

echo ""
echo "6. Public IP for Frontend:"
kubectl get service frontend-service -n hmi-yolo -o wide