@echo off
echo ========================================
echo Testing ClientVault Application
echo ========================================
echo.

:: Get the application URL
for /f "tokens=*" %%i in ('minikube service clientvault-service -n clientvault --url') do set APP_URL=%%i
echo Application URL: %APP_URL%
echo.

:: Test 1: Get all clients (should be empty initially)
echo Test 1: GET all clients
echo ------------------------
curl -s %APP_URL%/clients/all
echo.
echo.

:: Test 2: Create a new client
echo Test 2: POST new client
echo -----------------------
curl -s -X POST %APP_URL%/clients/add ^
  -H "Content-Type: application/json" ^
  -d "{\"clientId\":\"C115\",\"fullName\":\"Teabo\",\"email\":\"Teaboabo@gmail.com\",\"phoneNumber\":\"0631177632\",\"address\":\"623 Joburg street\"}"
echo.
echo.

:: Test 3: Get all clients again
echo Test 3: GET all clients (after creation)
echo ----------------------------------------
curl -s %APP_URL%/clients/all
echo.
echo.

:: Test 4: Get specific client (assuming ID 1)
echo Test 4: GET client by ID 1
echo --------------------------
curl -s %APP_URL%/clients/1
echo.
echo.

echo ========================================
echo Testing Complete
echo ========================================
pause