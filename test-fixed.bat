@echo off
echo === Testing ClientVault Application ===
echo.

for /f "tokens=*" %%i in ('minikube service clientvault-service -n clientvault --url') do set APP_URL=%%i
echo Application URL: %APP_URL%
echo.

echo Test 1: GET all clients
curl -s "%APP_URL%/clients/all"
echo.
echo.

echo Test 2: Create new client
curl -s -X POST "%APP_URL%/clients/add" ^
  -H "Content-Type: application/json" ^
  -d "{\"clientId\":\"C115\",\"fullName\":\"Teabo\",\"email\":\"Teaboabo@gmail.com\",\"phoneNumber\":\"0631177632\",\"address\":\"623 Joburg street\"}"
echo.
echo.

echo Test 3: GET all clients again
curl -s "%APP_URL%/clients/all"
echo.
echo.

echo === Testing Complete ===
pause