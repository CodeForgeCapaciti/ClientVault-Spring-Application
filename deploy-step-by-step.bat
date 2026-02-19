@echo off
echo ========================================
echo ClientVault - Step by Step Deployment
echo ========================================
echo.

echo Step 1: Creating namespace...
kubectl apply -f k8s/namespace.yaml
if %errorlevel% neq 0 (
    echo Failed to create namespace
    pause
    exit /b %errorlevel%
)
echo Namespace created successfully
echo.

echo Step 2: Creating ConfigMap...
kubectl apply -f k8s/configmap.yaml
kubectl get configmap -n clientvault
echo.

echo Step 3: Creating Secret...
kubectl apply -f k8s/secret.yaml
kubectl get secret -n clientvault
echo.

echo Step 4: Deploying PostgreSQL...
kubectl apply -f k8s/postgres-deployment.yaml
echo Waiting for PostgreSQL pod to start...
timeout /t 5
echo.

echo Step 5: Checking PostgreSQL status...
:k8s_postgres_check
kubectl get pods -n clientvault -l app=postgres
echo Waiting for PostgreSQL to be ready...
kubectl wait --for=condition=ready pod -l app=postgres -n clientvault --timeout=60s
if %errorlevel% neq 0 (
    echo PostgreSQL not ready yet, waiting...
    timeout /t 10
    goto k8s_postgres_check
)
echo PostgreSQL is ready!
echo.

echo Step 6: Deploying Application...
kubectl apply -f k8s/app-deployment.yaml
echo.

echo Step 7: Creating Services...
kubectl apply -f k8s/services.yaml
echo.

echo Step 8: Checking application status...
:k8s_app_check
kubectl get pods -n clientvault -l app=clientvault
echo Waiting for application to be ready...
kubectl wait --for=condition=ready pod -l app=clientvault -n clientvault --timeout=120s
if %errorlevel% neq 0 (
    echo Application not ready yet, waiting...
    timeout /t 10
    goto k8s_app_check
)
echo.

echo ========================================
echo Deployment Complete!
echo ========================================
echo.

echo All resources in clientvault namespace:
kubectl get all -n clientvault
echo.

echo Getting application URL...
for /f "tokens=*" %%i in ('minikube service clientvault-service -n clientvault --url') do set APP_URL=%%i
echo Application URL: %APP_URL%
echo.

echo PostgreSQL logs:
kubectl logs -l app=postgres -n clientvault --tail=20
echo.

echo Application logs:
kubectl logs -l app=clientvault -n clientvault --tail=20
echo.

echo ========================================
echo To test the application, run: test-app.bat
echo ========================================
pause