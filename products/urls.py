from django.urls import path
from . import views

urlpatterns = [
    path('', views.product_list, name='product_list'),
    path('add/', views.product_add, name='product_add'),
    path('export/excel/', views.export_products_excel, name='export_excel'),
    path('export/pdf/', views.export_products_pdf, name='export_pdf'),
]