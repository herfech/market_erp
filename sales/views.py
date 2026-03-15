from django.shortcuts import render
from django.db.models import Sum, F
from products.models import Product

def dashboard(request):
    products = Product.objects.all()
    total_value = products.aggregate(
        total=Sum(F('price') * F('stock'))
    )['total'] or 0
    
    critical_stock_count = products.filter(stock__lte=5).count()
    total_products = products.count()

    context = {
        'total_value': total_value,
        'critical_count': critical_stock_count,
        'total_products': total_products,
    }
    
    return render(request, 'sales/dashboard.html', context)