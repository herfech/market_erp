# Market ERP - Sistema de Gestión de Inventario

Este sistema permite gestionar productos, categorías y realizar ventas rápidas con actualización de stock en tiempo real.

## 🛠️ Instalación Inicial

1. **Clonar el proyecto** y entrar a la carpeta.
   ```bash
   git clone https://github.com/herfech/market_erp.git
   ```
2. **Entren en la carpeta**
   ```bash
   cd market_erp
   ```
   
3. **Crear entorno virtual**:
   ```bash
   python -m venv venv
   .\venv\Scripts\activate

4. Instalar dependencias:
   ```bash
   pip install -r requirements.txt
   ```
5. Antes de empezar a programar
   ```bash
   Ejecuta el archivo: .\update_project.bat
   ```
6. Preparar base de datos:
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

7. Crear usuario administrador:
   ```bash
   python manage.py createsuperuser
   python manage.py runserver
   ```

🚀 Ejecución
Para iniciar el servidor, usa:
   ```bash
   python manage.py runserver
   ```
