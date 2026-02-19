@echo off
echo === ClientVault Fixed Deployment ===
echo.

echo Step 1: Stopping Minikube...
minikube stop

echo Step 2: Deleting old cluster...
minikube delete

echo Step 3: Starting fresh Minikube...
minikube start --driver=docker --cpus=2 --memory=3000 --kubernetes-version=v1.28.3

echo Step 4: Updating kubectl context...
minikube update-context

echo Step 5: Verifying connection...
kubectl get nodes

echo Step 6: Creating namespace first...
kubectl apply -f k8s/namespace.yaml

echo Step 7: Applying ConfigMap and Secret...
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

echo Step 8: Deploying PostgreSQL...
kubectl apply -f k8s/postgres-deployment.yaml

echo Step 9: Waiting for PostgreSQL to be ready...
timeout /t 20
kubectl wait --for=condition=ready pod -l app=postgres -n clientvault --timeout=120s

echo Step 10: Deploying Application...
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/services.yaml

echo Step 11: Waiting for application to be ready...
timeout /t 20
kubectl wait --for=condition=ready pod -l app=clientvault -n clientvault --timeout=120s

echo Step 12: Deployment Status:
kubectl get all -n clientvault

echo.
echo Step 13: Application URL:
minikube service clientvault-service -n clientvault --url

echo.
echo === Deployment Complete ===
pause