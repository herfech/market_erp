from django.shortcuts import render
from products.models import Product
from sales.models import Sale

def dashboard(request):
    total_products = Product.objects.count()
    today_sales = Sale.objects.count()
    
    context = {
        'total_products': total_products,
        'today_sales': today_sales,
    }
    return render(request, 'dashboard.html', context)