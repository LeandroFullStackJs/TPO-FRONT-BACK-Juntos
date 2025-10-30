@echo off
echo ================================================= 
echo    LEVANTANDO BACKEND Y FRONTEND - E-COMMERCE
echo =================================================

echo.
echo Iniciando Backend (Spring Boot) en puerto 8080...
start "Backend" cmd /c "cd /d \"c:\Users\Leandro\Desktop\BACK Y FRONT JUNTOS\TPO-Ecommerce-Back\" && mvnw.cmd spring-boot:run"

echo.
echo Esperando 15 segundos para que el backend inicie...
timeout /t 15 /nobreak > nul

echo.
echo Iniciando Frontend (React + Vite) en puerto 5173...
start "Frontend" cmd /c "cd /d \"c:\Users\Leandro\Desktop\BACK Y FRONT JUNTOS\TPO-Ecommerce-Front\" && npm run dev"

echo.
echo Ambos servicios estan iniciandose...
echo.
echo URLs de acceso:
echo   Frontend: http://localhost:5173
echo   Backend:  http://localhost:8080/api
echo.
echo Para detener los servicios, cierra las ventanas de cmd que se abrieron
echo.
pause