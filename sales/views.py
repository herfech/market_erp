import json
from django.shortcuts import render
from django.db.models import Count, Sum
from products.models import Product
from .models import Sale, SaleDetail
from django.http import JsonResponse
from django.utils import timezone

def dashboard(request):
    products = Product.objects.all()

    total_value = sum((float(p.price or 0) * int(p.stock or 0)) for p in products)

    category_data = Product.objects.values('category__name').annotate(total=Count('id'))
    labels = [item['category__name'] or "Genel" for item in category_data]
    counts = [item['total'] for item in category_data]

    today = timezone.now().date()
   
    sales_query = Sale.objects.filter(date__date=today).aggregate(total=Sum('total_amount'))
    total_sales_today = sales_query['total'] or 0

    context = {
        'total_value': total_value,
        'total_sales_today': total_sales_today,
        'total_products': products.count(),
        'critical_count': products.filter(stock__lte=5).count(),
        'labels': json.dumps(labels),
        'counts': json.dumps(counts),
        'recent_products': products.order_by('-id')[:5],
    }
    return render(request, 'sales/dashboard.html', context)

def quick_sale(request):
    if request.method == 'POST':
        product_id = request.POST.get('product_id')
        try:
            product = Product.objects.get(id=product_id)
            if product.stock > 0:
                product.stock -= 1
                product.save()
                new_sale = Sale.objects.create(
                    total_amount=product.price,
                    payment_method='Nakit'
                )

                SaleDetail.objects.create(
                    sale=new_sale,
                    product=product,
                    quantity=1,
                    unit_price=product.price,
                    subtotal=product.price
                )

                return JsonResponse({'status': 'success', 'price': str(product.price)})
            return JsonResponse({'status': 'error', 'message': 'Stok yetersiz!'})
        except Product.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Ürün bulunamadı'})
    return JsonResponse({'status': 'error'})