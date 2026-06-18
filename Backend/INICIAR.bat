@echo off
chcp 65001 > nul
title ☕ Cafetería API — Docker

echo.
echo  ══════════════════════════════════════════
echo   ☕  CAFETERÍA UNIVERSITARIA — Backend
echo  ══════════════════════════════════════════
echo.
echo  Levantando base de datos + API...
echo  Esto puede tardar 1-2 minutos la primera vez.
echo.

:: Verificar que Docker esté corriendo
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo  [ERROR] Docker no está corriendo.
    echo  Por favor abre Docker Desktop y vuelve a intentarlo.
    echo.
    pause
    exit /b 1
)

:: Detener contenedores previos si existen
echo  Limpiando contenedores anteriores...
docker-compose down > nul 2>&1

:: Construir y levantar todo
echo  Construyendo imagen y levantando servicios...
echo.
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo.
    echo  [ERROR] Hubo un problema al levantar los contenedores.
    echo  Revisa los logs con: docker-compose logs
    pause
    exit /b 1
)

echo.
echo  Esperando que los servicios estén listos...
timeout /t 5 /nobreak > nul

echo.
echo  ══════════════════════════════════════════
echo   ✅  API corriendo en: http://localhost:3000
echo   ✅  PostgreSQL en:    localhost:5432
echo  ══════════════════════════════════════════
echo.
echo   Endpoints disponibles:
echo     GET  /api/productos
echo     POST /api/productos
echo     GET  /api/pedidos
echo     POST /api/pedidos
echo     GET  /health
echo.
echo   Para detener: ejecuta DETENER.bat
echo   O corre:      docker-compose down
echo.
pause
