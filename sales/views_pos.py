# ═══════════════════════════════════════════════════════════════
# ARCHIVO DE DIAGNÓSTICO — sales/views_pos.py
# Vista completamente nueva, independiente de views.py existente
# ═══════════════════════════════════════════════════════════════
import json
from decimal import Decimal
from django.http import JsonResponse
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.views.decorators.http import require_http_methods

from products.models import Product
from .models import Sale, SaleDetail


@login_required
@require_http_methods(["GET"])
def pos_view(request):
    """Renderiza la página del nuevo POS."""
    products = list(
        Product.objects.filter(stock__gt=0)
        .values('id', 'name', 'price', 'stock')
        .order_by('name')
    )
    # Convertir Decimal a float para JSON
    for p in products:
        p['price'] = float(p['price'])

    return render(request, 'sales/pos.html', {
        'products_json': json.dumps(products)
    })


@login_required
@require_http_methods(["POST"])
@transaction.atomic
def pos_sell(request):
    """
    Endpoint de venta — completamente nuevo y aislado.
    Espera: POST JSON  { "items": [{"id": 1, "qty": 2}, ...] }
    """
    # 1. Parsear JSON
    try:
        body = json.loads(request.body)
    except (json.JSONDecodeError, Exception):
        return JsonResponse({'ok': False, 'msg': 'JSON geçersiz'}, status=400)

    items = body.get('items', [])
    if not items:
        return JsonResponse({'ok': False, 'msg': 'Sepet boş'}, status=400)

    # 2. Validar TODOS los productos antes de tocar nada
    validated = []
    for item in items:
        try:
            pid = int(item['id'])
            qty = int(item['qty'])
            assert qty > 0
        except Exception:
            return JsonResponse({'ok': False, 'msg': f'Geçersiz satır: {item}'}, status=400)

        try:
            # select_for_update bloquea la fila hasta que termine la transacción
            product = Product.objects.select_for_update().get(pk=pid)
        except Product.DoesNotExist:
            return JsonResponse({'ok': False, 'msg': f'Ürün bulunamadı: ID {pid}'}, status=400)

        if product.stock < qty:
            return JsonResponse({
                'ok': False,
                'msg': f'Yetersiz stok → "{product.name}" (mevcut: {product.stock}, istenen: {qty})'
            }, status=400)

        validated.append({'product': product, 'qty': qty})

    # 3. Crear la venta
    sale = Sale.objects.create(
        user=request.user,
        total_amount=Decimal('0'),
        payment_method='Nakit',
        is_cancelled=False,
    )

    total = Decimal('0')
    for v in validated:
        product = v['product']
        qty     = v['qty']
        price   = Decimal(str(product.price))
        sub     = price * qty

        # 3a. Descontar stock
        Product.objects.filter(pk=product.pk).update(stock=product.stock - qty)

        # 3b. Crear detalle
        SaleDetail.objects.create(
            sale=sale,
            product=product,
            quantity=qty,
            unit_price=price,
            subtotal=sub,
        )
        total += sub

    # 4. Guardar total
    sale.total_amount = total
    sale.save(update_fields=['total_amount'])

    return JsonResponse({
        'ok': True,
        'sale_id': sale.id,
        'total': str(total),
        'msg': f'Satış #{sale.id} tamamlandı — {total} TL'
    })
