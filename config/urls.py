from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
from .views import dashboard

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', dashboard, name='dashboard'),
    path('accounts/login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name='login'),
    path('accounts/', include('django.contrib.auth.urls')),
    path('inventory/', include('products.urls')), 
]