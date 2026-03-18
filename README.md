# Market ERP - Sistema de Gestión de Inventario

Este sistema permite gestionar productos, categorías y realizar ventas rápidas con actualización de stock en tiempo real.

## 🛠️ Instalación Inicial

1. **Clonar el proyecto** y entrar a la carpeta.
2. **Crear entorno virtual**:
   ```bash
   python -m venv venv
   .\venv\Scripts\activate

3. Instalar dependencias:
  pip install -r requirements.txt

4. Preparar base de datos:
  python manage.py makemigrations
  python manage.py migrate

5. Crear usuario administrador:
  python manage.py createsuperuser
  python manage.py runserver

🚀 Ejecución
Para iniciar el servidor, usa:
  python manage.py runserver
