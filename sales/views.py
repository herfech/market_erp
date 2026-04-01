import json
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Count, Sum
from products.models import Product
from .models import Sale, SaleDetail
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta
from django.contrib.auth.decorators import login_required, user_passes_test

def is_admin(user):
    return user.groups.filter(name='Admin').exists() or user.is_superuser

@login_required
def dashboard(request):
    products = Product.objects.all()
    today = timezone.now().date()
    user = request.user

    PRODUCT_GROUP = 'Ürün Yönetimi (products)'
    SECURITY_GROUP = 'Hesap Güvenliği ve Erişim Sorumlusu'
    SALES_GROUP = 'Satış Mantığı ve Finans Sorumlusu (Ventas)'

    if user.is_superuser:
        team_role = "Sistem Entegratörü & UI/UX Sorumlusu"
    elif user.groups.filter(name=PRODUCT_GROUP).exists():
        team_role = "Ürün Yönetimi & Sözcü"
    elif user.groups.filter(name=SECURITY_GROUP).exists():
        team_role = "Hesap Güvenliği Sorumlusu"
    elif user.groups.filter(name=SALES_GROUP).exists():
        team_role = "Satış ve Finans Uzmanı"
    else:
        team_role = "Kasiyer"
    
    user_is_admin = is_admin(user)

    can_add_products = (
        user_is_admin or 
        user.groups.filter(name=PRODUCT_GROUP).exists() or
        user.has_perm('products.add_product')
    )
    
    next_week = today + timedelta(days=7)
    next_month = today + timedelta(days=30)
    expired_count = products.filter(expiration_date__lt=today).count()
    expiring_soon = products.filter(expiration_date__range=[today, next_week]).count()
    expiring_month = products.filter(expiration_date__range=[next_week, next_month]).count()
    
    total_value = 0
    labels = []
    counts = []    

    if user_is_admin:
        if expired_count > 0:
            messages.error(request, f'Dikkat: Sistemde tarihi geçmiş {expired_count} adet ürün bulundu!')
        elif expiring_soon > 0:
            messages.warning(request, f'Bilgi: Önümüzdeki 7 gün içinde süresi dolacak {expiring_soon} ürün var.')

        total_value = sum((float(p.price or 0) * int(p.stock or 0)) for p in products)

        category_data = Product.objects.values('category__name').annotate(total=Count('id'))
        labels = [item['category__name'] or "Genel" for item in category_data]
        counts = [item['total'] for item in category_data]
   
    sales_query = Sale.objects.filter(date__date=today, is_cancelled=False).aggregate(total=Sum('total_amount'))
    total_sales_today = sales_query['total'] or 0

    context = {
        'team_role': team_role,
        'full_name': user.get_full_name() or user.username,
        'user_is_admin': user_is_admin,
        'can_add_products': can_add_products,
        'total_value': total_value,
        'total_sales_today': total_sales_today,
        'total_products': products.count(),
        'critical_count': products.filter(stock__lte=5).count(),
        'expired_count': expired_count,
        'expiring_soon': expiring_soon,
        'expiring_month': expiring_month,
        'labels': json.dumps(labels),
        'counts': json.dumps(counts),
        'recent_products': products.order_by('-id')[:5],
    }
    return render(request, 'sales/dashboard.html', context)

@login_required
def quick_sale(request):
    if request.method == 'POST':
        product_id = request.POST.get('product_id')
        qty_to_sell = 1
        try:
            product = Product.objects.get(id=product_id)
            if product.stock >= qty_to_sell:
                product.stock -= qty_to_sell
                product.save()
                
                new_sale = Sale.objects.create(
                    total_amount=product.price * qty_to_sell,
                    payment_method='Nakit'
                )

                SaleDetail.objects.create(
                    sale=new_sale,
                    product=product,
                    quantity=qty_to_sell,
                    unit_price=product.price,
                    subtotal=product.price * qty_to_sell
                )

                return JsonResponse({
                    'status': 'success',
                    'price': str(product.price),
                    'new_stock': product.stock
                })
            return JsonResponse({'status': 'error', 'message': 'Stok yetersiz!'})
        except Product.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Ürün bulunamadı'})
    return JsonResponse({'status': 'error'})


@login_required
def sale_history(request):
    today = timezone.now().date()
    sales = Sale.objects.filter(date__date=today).order_by('-date')
    
    cash_total = sales.filter(is_cancelled=False, payment_method='Nakit').aggregate(Sum('total_amount'))['total_amount__sum'] or 0
    card_total = sales.filter(is_cancelled=False, payment_method='Kart').aggregate(Sum('total_amount'))['total_amount__sum'] or 0

    return render(request, 'sales/sale_history.html', {
        'sales': sales,
        'cash_total': cash_total,
        'card_total': card_total,
        'grand_total': cash_total + card_total
    })

@login_required
def cancel_sale(request, sale_id):
    sale = get_object_or_404(Sale, id=sale_id)
    
    if not sale.is_cancelled:
        for item in sale.items.all():
            product = item.product
            product.stock += item.quantity
            product.save()
        
        sale.is_cancelled = True
        sale.save()
        messages.success(request, f'Satış #{sale.id} iptal edildi. Ürünler stoka geri eklendi.')
    else:
        messages.warning(request, 'Bu satış zaten iptal edilmiş.')
        
    return redirect('sale_history')