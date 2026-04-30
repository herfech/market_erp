from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.auth import views as auth_views
from sales.views import dashboard, quick_sale, sale_history, cancel_sale, generate_receipt_pdf, product_search_api
from .views import home, SignUpView

app_name = 'sales'

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
    path('dashboard/', dashboard, name='dashboard'),
    path('accounts/signup/', SignUpView.as_view(), name='signup'),
    path('accounts/login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name='login'),
    path('accounts/', include('django.contrib.auth.urls')),
    path('inventory/', include('products.urls')),
    path('quick-sale/', quick_sale, name='quick_sale'),
    path('sales/history/', sale_history, name='sale_history'),
    path('sales/cancel/<int:sale_id>/', cancel_sale, name='cancel_sale'),
    path('api/product-search/', product_search_api, name='product_search_api'),
    path('api/quick-sale-api/', quick_sale, name='quick_sale_api'),
    path('sale/receipt/<int:sale_id>/', generate_receipt_pdf, name='generate_receipt_pdf'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)