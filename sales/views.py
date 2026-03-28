import json
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Count, Sum
from products.models import Product
from .models import Sale, SaleDetail
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta
from django.contrib.auth.decorators import login_required

@login_required
def dashboard(request):
    products = Product.objects.all()
    today = timezone.now().date()

    # --- LÓGICA DE VENCIMIENTOS ---
    next_week = today + timedelta(days=7)
    next_month = today + timedelta(days=30)
    expired_count = products.filter(expiration_date__lt=today).count()
    expiring_soon = products.filter(expiration_date__range=[today, next_week]).count()
    expiring_month = products.filter(expiration_date__range=[next_week, next_month]).count()

    if expired_count > 0:
        messages.error(request, f'Dikkat: Sistemde tarihi geçmiş {expired_count} adet ürün bulundu!')
    elif expiring_soon > 0:
        messages.warning(request, f'Bilgi: Önümüzdeki 7 gün içinde süresi dolacak {expiring_soon} ürün var.')

    # --- MÉTRICAS ---
    total_value = sum((float(p.price or 0) * int(p.stock or 0)) for p in products)
    category_data = Product.objects.values('category__name').annotate(total=Count('id'))
    labels = [item['category__name'] or "Genel" for item in category_data]
    counts = [item['total'] for item in category_data]
   
    # Solo sumamos ventas NO anuladas
    sales_query = Sale.objects.filter(date__date=today, is_cancelled=False).aggregate(total=Sum('total_amount'))
    total_sales_today = sales_query['total'] or 0

    context = {
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
                
                # CORREGIDO: Solo una creación de venta
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

# --- NUEVAS FUNCIONES DE HISTORIAL Y ANULACIÓN ---

@login_required
def sale_history(request):
    today = timezone.now().date()
    # Traemos las ventas de hoy, incluyendo las anuladas para transparencia
    sales = Sale.objects.filter(date__date=today).order_by('-date')
    
    # Resumen de caja por método
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
        # Devolver el stock de cada producto vendido en esta transacción
        for item in sale.items.all(): # 'items' es el related_name en SaleDetail
            product = item.product
            product.stock += item.quantity
            product.save()
        
        sale.is_cancelled = True
        sale.save()
        messages.success(request, f'Satış #{sale.id} iptal edildi. Ürünler stoka geri eklendi.')
    else:
        messages.warning(request, 'Bu satış zaten iptal edilmiş.')
        
    return redirect('sale_history')