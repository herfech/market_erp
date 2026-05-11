import json
import os
from decimal import Decimal

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.db.models import Count, Sum, Q
from django.db import transaction
from django.http import JsonResponse, HttpResponse
from django.utils import timezone
from datetime import timedelta
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_http_methods
from django.conf import settings

from products.models import Product
from .models import Sale, SaleDetail

# PDF
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm


def is_admin(user):
    return user.is_superuser or user.groups.filter(name='Admin').exists()


@login_required
def dashboard(request):
    products = Product.objects.all()
    now   = timezone.now()
    today = now.date()
    user  = request.user

    PRODUCT_GROUP  = 'Ürün Yönetimi (products)'
    SECURITY_GROUP = 'Hesap Güvenliği ve Erişim Sorumlusu'
    SALES_GROUP    = 'Satış Mantığı ve Finans Sorumlusu (Ventas)'

    if user.is_superuser:
        team_role = "Sistem Entegratörü ve UI/UX Yöneticisi"
    elif user.groups.filter(name=PRODUCT_GROUP).exists():
        team_role = "Ürün Yönetimi ve Sözcü"
    elif user.groups.filter(name=SECURITY_GROUP).exists():
        team_role = "Güvenlik Yöneticisi"
    elif user.groups.filter(name=SALES_GROUP).exists():
        team_role = "Satış ve Finans Uzmanı"
    else:
        team_role = "Kasiyer"

    user_is_admin    = is_admin(user)
    can_add_products = (
        user_is_admin or
        user.groups.filter(name=PRODUCT_GROUP).exists() or
        user.has_perm('products.add_product')
    )

    next_week  = today + timedelta(days=7)
    next_month = today + timedelta(days=30)

    expired_count  = products.filter(expiration_date__lt=today).count()
    expiring_soon  = products.filter(expiration_date__range=[today, next_week]).count()
    expiring_month = products.filter(expiration_date__range=[next_week, next_month]).count()

    total_value = 0
    labels = []
    counts = []

    if user_is_admin:
        if expired_count > 0:
            messages.error(request, f'Uyarı: Sistemde {expired_count} adet süresi dolmuş ürün bulundu!')
        elif expiring_soon > 0:
            messages.warning(request, f'Bilgi: {expiring_soon} ürünün süresi 7 gün içinde dolacak.')
        total_value   = sum((Decimal(str(p.price or 0)) * int(p.stock or 0)) for p in products)
        category_data = Product.objects.values('category__name').annotate(total=Count('id'))
        labels        = [item['category__name'] or "Genel" for item in category_data]
        counts        = [item['total'] for item in category_data]

    daily = Sale.objects.filter(
        date__year=now.year, date__month=now.month, date__day=now.day, is_cancelled=False
    ).aggregate(total=Sum('total_amount'))

    context = {
        'team_role':        team_role,
        'full_name':        user.get_full_name() or user.username,
        'user_is_admin':    user_is_admin,
        'can_add_products': can_add_products,
        'total_value':      total_value,
        'total_sales_today':daily['total'] or 0,
        'total_products':   products.count(),
        'critical_count':   products.filter(stock__lte=5).count(),
        'expired_count':    expired_count,
        'expiring_soon':    expiring_soon,
        'expiring_month':   expiring_month,
        'labels':           json.dumps(labels),
        'counts':           json.dumps(counts),
        'recent_products':  products.order_by('-id')[:5],
        'recent_sales':     Sale.objects.all().order_by('-date')[:5],
    }
    return render(request, 'sales/dashboard.html', context)


@login_required
@require_http_methods(["GET"])
def pos_view(request):
    """Renderiza la página del POS (quick_sale.html)."""
    products = list(
        Product.objects.filter(stock__gt=0)
        .values('id', 'name', 'price', 'stock')
        .order_by('name')
    )
    for p in products:
        p['price'] = float(p['price'])

    return render(request, 'sales/quick_sale.html', {
        'products_json': json.dumps(products)
    })


@login_required
@require_http_methods(["POST"])
@transaction.atomic
def pos_sell(request):
    """
    POST /pos/sell/
    Body: { "items": [{"id": 1, "qty": 2}, ...], "payment_method": "Nakit" }
    Responde: { "ok": true/false, "msg": "...", "sale_id": N, "total": "N.NN" }
    """
    try:
        body = json.loads(request.body)
    except Exception:
        return JsonResponse({'ok': False, 'msg': 'JSON geçersiz'}, status=400)

    items          = body.get('items', [])
    payment_method = body.get('payment_method', 'Nakit')
    if payment_method not in ('Nakit', 'Kart'):
        payment_method = 'Nakit'

    if not items:
        return JsonResponse({'ok': False, 'msg': 'Sepet boş'}, status=400)


    validated = []
    for item in items:
        try:
            pid = int(item['id'])
            qty = int(item['qty'])
            assert qty > 0
        except Exception:
            return JsonResponse({'ok': False, 'msg': f'Geçersiz satır: {item}'}, status=400)

        try:
            product = Product.objects.select_for_update().get(pk=pid)
        except Product.DoesNotExist:
            return JsonResponse({'ok': False, 'msg': f'Ürün bulunamadı: ID {pid}'}, status=400)

        if product.stock < qty:
            return JsonResponse({
                'ok': False,
                'msg': f'Yetersiz stok → "{product.name}" (mevcut: {product.stock}, istenen: {qty})'
            }, status=400)

        validated.append({'product': product, 'qty': qty})


    sale = Sale.objects.create(
        user=request.user,
        total_amount=Decimal('0'),
        payment_method=payment_method,
        is_cancelled=False,
    )

    total = Decimal('0')
    for v in validated:
        product = v['product']
        qty     = v['qty']
        price   = Decimal(str(product.price))
        sub     = price * qty

        Product.objects.filter(pk=product.pk).update(stock=product.stock - qty)

        SaleDetail.objects.create(
            sale=sale,
            product=product,
            quantity=qty,
            unit_price=price,
            subtotal=sub,
        )
        total += sub

    sale.total_amount = total
    sale.save(update_fields=['total_amount'])

    return JsonResponse({
        'ok':     True,
        'sale_id':sale.id,
        'total':  str(total),
        'msg':    f'Satış #{sale.id} tamamlandı — {total} TL',
    })


@login_required
def product_search_api(request):
    query    = request.GET.get('q', '')
    products = Product.objects.filter(
        Q(name__icontains=query) | Q(barcode__icontains=query)
    )[:10]
    return JsonResponse({'products': [
        {'id': p.id, 'name': p.name, 'price': str(p.price), 'stock': p.stock}
        for p in products
    ]})



@login_required
def sale_history(request):
    today = timezone.now().date()
    sales = Sale.objects.filter(date__date=today).order_by('-date')
    totals = sales.filter(is_cancelled=False).aggregate(
        total=Sum('total_amount'),
        cash=Sum('total_amount', filter=Q(payment_method='Nakit')),
        card=Sum('total_amount', filter=Q(payment_method='Kart')),
    )
    return render(request, 'sales/sale_history.html', {
        'sales':       sales,
        'grand_total': totals['total'] or 0,
        'cash_total':  totals['cash']  or 0,
        'card_total':  totals['card']  or 0,
    })


@login_required
def full_sale_history(request):
    start_date = request.GET.get('start_date')
    end_date   = request.GET.get('end_date')
    sales      = Sale.objects.all().order_by('-date')
    if start_date and end_date:
        sales = sales.filter(date__date__range=[start_date, end_date])
    totals = sales.filter(is_cancelled=False).aggregate(
        total=Sum('total_amount'),
        cash=Sum('total_amount', filter=Q(payment_method='Nakit')),
        card=Sum('total_amount', filter=Q(payment_method='Kart')),
    )
    return render(request, 'sales/full_sale_history.html', {
        'sales':       sales,
        'grand_total': totals['total'] or 0,
        'cash_total':  totals['cash']  or 0,
        'card_total':  totals['card']  or 0,
        'start_date':  start_date,
        'end_date':    end_date,
    })



@login_required
def cancel_sale(request, sale_id):
    sale = get_object_or_404(Sale, id=sale_id)
    if not sale.is_cancelled:
        for item in sale.items.all():
            item.product.stock += item.quantity
            item.product.save(update_fields=['stock'])
        sale.is_cancelled = True
        sale.save(update_fields=['is_cancelled'])
        messages.success(request, f'Satış #{sale.id} iptal edildi. Ürünler stoka geri eklendi.')
    else:
        messages.warning(request, 'Bu satış zaten iptal edilmiş.')
    return redirect('sale_history')


@login_required
def generate_receipt_pdf(request, sale_id):
    sale     = get_object_or_404(Sale, id=sale_id)
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="Fis_{sale.id}.pdf"'

    font_dir = os.path.join(settings.BASE_DIR, 'templates', 'static', 'fonts')
    try:
        pdfmetrics.registerFont(TTFont('DejaVuSans',
                                       os.path.join(font_dir, 'DejaVuSans.ttf')))
        pdfmetrics.registerFont(TTFont('DejaVuSans-Bold',
                                       os.path.join(font_dir, 'DejaVuSans-Bold.ttf')))
        f_name, f_bold = 'DejaVuSans', 'DejaVuSans-Bold'
    except Exception:
        f_name, f_bold = 'Helvetica', 'Helvetica-Bold'

    doc      = SimpleDocTemplate(response, pagesize=(80*mm, 150*mm),
                                 rightMargin=5*mm, leftMargin=5*mm,
                                 topMargin=5*mm, bottomMargin=5*mm)
    styles   = getSampleStyleSheet()
    sc = ParagraphStyle('C', parent=styles['Normal'], fontName=f_name, alignment=1, fontSize=9)
    sl = ParagraphStyle('L', parent=styles['Normal'], fontName=f_name, fontSize=8)
    sb = ParagraphStyle('B', parent=styles['Normal'], fontName=f_bold, alignment=1, fontSize=10)

    elements = [
        Paragraph("MARKET ERP SOLUTIONS", sb),
        Paragraph("Gümüşhane / Türkiye", sc),
        Paragraph("-" * 35, sc),
        Paragraph(f"Tarih: {sale.date.strftime('%d.%m.%Y %H:%M')}", sl),
        Paragraph(f"Fiş No: #{sale.id}", sl),
        Paragraph(f"Kasiyer: {sale.user.get_full_name() if sale.user else 'Sistem'}", sl),
        Paragraph("-" * 35, sc),
    ]

    tbl_data = [['Ürün', 'Adet', 'Tutar']]
    for item in sale.items.all():
        name = (item.product.name[:15] + '..') if len(item.product.name) > 15 else item.product.name
        tbl_data.append([name, str(item.quantity), str(item.subtotal)])

    tbl = Table(tbl_data, colWidths=[35*mm, 10*mm, 20*mm])
    tbl.setStyle(TableStyle([
        ('FONTNAME',  (0, 0), (-1, -1), f_name),
        ('FONTSIZE',  (0, 0), (-1, -1), 8),
        ('ALIGN',     (1, 0), (1,  -1), 'CENTER'),
        ('ALIGN',     (2, 0), (2,  -1), 'RIGHT'),
        ('LINEBELOW', (0, 0), (-1,  0), 0.5, colors.black),
    ]))
    elements += [
        tbl,
        Paragraph("-" * 35, sc),
        Paragraph(f"TOPLAM: {sale.total_amount} TL", sb),
        Spacer(1, 10),
        Paragraph("Teşekkür Ederiz!", sc),
    ]
    doc.build(elements)
    return response
