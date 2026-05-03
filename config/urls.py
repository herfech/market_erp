from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.auth import views as auth_views

# --- IMPORTACIONES ACTUALIZADAS ---
# Agregamos 'full_sale_history' a la lista para que no dé error abajo
from sales.views import (
    dashboard, quick_sale, sale_history, 
    full_sale_history, cancel_sale, 
    generate_receipt_pdf, product_search_api
)
from .views import home, SignUpView

# Nota: app_name se usa generalmente cuando incluyes este archivo en otro. 
# Si es tu archivo principal, lo dejamos como estaba por tu flujo de trabajo.
app_name = 'sales'

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
    
    # Dashboard
    path('dashboard/', dashboard, name='dashboard'),
    
    # Accounts
    path('accounts/signup/', SignUpView.as_view(), name='signup'),
    path('accounts/login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name='login'),
    path('accounts/', include('django.contrib.auth.urls')),
    
    # Inventory (App Products)
    path('inventory/', include('products.urls')),
    
    # Sales Logic
    path('quick-sale/', quick_sale, name='quick_sale'),
    path('sales/history/', sale_history, name='sale_history'),
    path('sales/history/full/', full_sale_history, name='full_sale_history'), # <--- Ya no tendrá línea amarilla
    path('sales/cancel/<int:sale_id>/', cancel_sale, name='cancel_sale'),
    path('sale/receipt/<int:sale_id>/', generate_receipt_pdf, name='generate_receipt_pdf'),

    # APIs
    path('api/product-search/', product_search_api, name='product_search_api'),
    path('api/quick-sale-api/', quick_sale, name='quick_sale_api'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)