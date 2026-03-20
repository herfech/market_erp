@echo off
cls
echo ===========================================
echo   MARKET ERP - RESPALDO Y SUBIDA
echo ===========================================

echo [1/4] XAMPP'ten veritabanı dışa aktarılıyor...
C:\xampp\mysql\bin\mysqldump.exe -u root market_db > database_backup.sql

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Veritabanı yedeği alınamadı. XAMPP açık mı?
    pause
    exit /b
)

echo [2/4] GitHub için dosyalar hazırlanıyor...
git add .
set commit_msg="Backup integral: %date% %time%"
git commit -m %commit_msg%

echo [3/4] Sincronizando con GitHub (Pull)...
:: Esto limpia el camino antes de subir
git pull origin main --rebase

echo [4/4] GitHub'a yükleniyor (Push)...
git push origin main

:: Revisamos si el comando final falló
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo [ERROR] Algo salió mal. 
    echo Si hay conflictos, deberás resolverlos manualmente.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit /b
)

echo ---------------------------------------
echo [BAŞARI] Kod ve Veriler başarıyla kaydedildi.
echo ---------------------------------------
pause