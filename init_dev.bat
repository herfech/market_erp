@echo off
echo [1/3] Instalando librerias necesarias...
pip install -r requirements.txt

echo [2/3] Creando tablas en la base de datos MySQL...
python manage.py migrate

echo [3/3] Crea tu acceso de Administrador:
echo (Ingresa un nombre de usuario, correo y contrasena que no olvides)
python manage.py createsuperuser

echo --------------------------------------------------
echo [LISTO] Entorno configurado. 
echo Recuerda tener XAMPP encendido con MySQL corriendo.
echo --------------------------------------------------
pause