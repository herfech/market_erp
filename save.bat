@echo off
cls
echo ===========================================
echo   MARKET ERP - RESPALDO Y SUBIDA
echo ===========================================

echo [1/3] XAMPP'ten veritabanı dışa aktarılıyor...
C:\xampp\mysql\bin\mysqldump.exe -u root market_db > database_backup.sql

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Veritabanı yedeği alınamadı. XAMPP açık mı?
    pause
    exit /b
)

echo [2/3] GitHub için dosyalar hazırlanıyor...
git add .
set commit_msg="Backup integral: %date% %time%"
git commit -m %commit_msg%

echo [3/3] GitHub'a yükleniyor...
git push origin main

:: Aquí revisamos si el comando git push falló
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo [ERROR] Yükleme başarısız! (REJECTED)
    echo Lütfen terminale şunu yazın: git pull origin main --rebase
    echo Sonra tekrar bu scripti çalıştırın.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit /b
)

echo ---------------------------------------
echo [BAŞARI] Kod ve Veriler başarıyla kaydedildi.
echo ---------------------------------------
pause