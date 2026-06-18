@echo off
chcp 65001 > nul
title ☕ Cafetería API — Detener

echo.
echo  Deteniendo todos los contenedores de Cafetería...
echo.

docker-compose down

echo.
echo  ✅ Contenedores detenidos correctamente.
echo  Los datos en la base de datos siguen guardados.
echo.
echo  Para borrar también los datos:
echo    docker-compose down -v
echo.
pause
