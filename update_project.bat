@echo off
echo [1/3] GitHub'dan en son kodlar indiriliyor...
git pull origin main

echo [2/3] Veritabanı güncelleniyor (Importing SQL)...
:: Nota: Esto borrará la DB local y pondrá la que está en el backup
C:\xampp\mysql\bin\mysql.exe -u root market_db < database_backup.sql

echo [3/3] Python bağımlılıkları kontrol ediliyor...
pip install -r requirements.txt

echo ---------------------------------------
echo [BAŞARI] Proje ve Veritabanı Güncellendi!
echo ---------------------------------------
pause