from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.auth import views as auth_views

from .views import home, SignUpView

# Todo viene de sales/views.py — un solo archivo
from sales.views import (
    dashboard,
    pos_view,
    pos_sell,
    sale_history,
    full_sale_history,
    cancel_sale,
    generate_receipt_pdf,
    product_search_api,
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),

    # Dashboard
    path('dashboard/', dashboard, name='dashboard'),

    # Accounts
    path('accounts/signup/', SignUpView.as_view(), name='signup'),
    path('accounts/login/', auth_views.LoginView.as_view(
        template_name='accounts/login.html'), name='login'),
    path('accounts/', include('django.contrib.auth.urls')),

    # Inventory
    path('inventory/', include('products.urls')),

    # POS — página y endpoint de venta
    path('pos/',      pos_view, name='pos_view'),
    path('pos/sell/', pos_sell, name='pos_sell'),

    # Aliases para que los links existentes sigan funcionando
    path('quick-sale/',       pos_view, name='quick_sale'),
    path('api/process-sale/', pos_sell, name='process_sale_api'),
    path('api/quick-sale/',   pos_sell, name='quick_sale_api'),

    # Historial
    path('sales/history/',              sale_history,         name='sale_history'),
    path('sales/history/full/',         full_sale_history,    name='full_sale_history'),
    path('sales/cancel/<int:sale_id>/', cancel_sale,          name='cancel_sale'),
    path('sale/receipt/<int:sale_id>/', generate_receipt_pdf, name='generate_receipt_pdf'),

    # API auxiliar (búsqueda en dashboard)
    path('api/product-search/', product_search_api, name='product_search_api'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
