from django.urls import path
from .views import inventory_list
from . import views

urlpatterns = [
    path('', views.product_list, name='product_list'),
    path('', inventory_list, name='inventory'),
]