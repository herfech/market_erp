from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from .views import dashboard, home, quick_sale, SignUpView
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),
    path('dashboard/', dashboard, name='dashboard'),
    path('accounts/signup/', SignUpView.as_view(), name='signup'),
    path('accounts/login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name='login'),
    path('accounts/', include('django.contrib.auth.urls')),
    path('inventory/', include('products.urls')),
    path('quick-sale/', quick_sale, name='quick_sale'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)