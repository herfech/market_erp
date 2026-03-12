@echo off
echo XAMPP'ten veritabanı dışa aktarılıyor...
C:\xampp\mysql\bin\mysqldump.exe -u root market_db > database_backup.sql

echo GitHub için dosyalar hazırlanıyor...
git add .

set commit_msg="Backup integral: %date% %time%"
git commit -m %commit_msg%

echo GitHub'a yükleniyor...
git push

echo ---------------------------------------
echo [BAŞARI] Kod ve Veriler başarıyla kaydedildi.
echo ---------------------------------------
pause