import os
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required, user_passes_test
from django.db.models import Sum, F
from .models import Product, Category
from .forms import ProductForm
import openpyxl
from django.http import HttpResponse
from django.contrib import messages
from django.utils import timezone
from django.conf import settings

from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT

def is_admin(user):
    return user.groups.filter(name='Admin').exists() or user.is_superuser

def can_manage_products(user):
    return (
        is_admin(user) or 
        user.groups.filter(name='Ürün Yönetimi (products)').exists()
    )

@login_required
def product_list(request):
    today = timezone.now().date()
    products = Product.objects.all()
    return render(request, 'products/inventory.html', {
        'products': products,
        'today': today
        })

@login_required
@user_passes_test(can_manage_products)
def product_add(request):
    if request.method == 'POST':
        form = ProductForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            new_stock = form.cleaned_data['stock']
            
            product = Product.objects.filter(name__iexact=name).first()
            
            if product:
                product.stock += new_stock
                product.price = form.cleaned_data['price'] 
                product.save()
                messages.success(request, f'Stock actualizado para {product.name}.')
            else:
                form.save()
                messages.success(request, 'Nuevo producto añadido con éxito.')
            
            return redirect('product_list')
    else:
        form = ProductForm()
    
    return render(request, 'products/product_form.html', {
        'form': form,
        'full_name': request.user.get_full_name() or request.user.username,
    })


@login_required
@user_passes_test(is_admin)
def export_products_excel(request):
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Envanter Raporu"
    headers = ['Ürün Adı', 'Kategori', 'Fiyat (TL)', 'Stok', 'SKT']
    ws.append(headers)

    products = Product.objects.all()
    for product in products:
        skt = product.expiration_date.strftime('%d.%m.%Y') if product.expiration_date else "-"
        ws.append([
            product.name, 
            product.category.name if product.category else "Genel",
            product.price, 
            product.stock,
            skt
        ])

    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    )
    response['Content-Disposition'] = 'attachment; filename="Envanter_Raporu.xlsx"'
    
    wb.save(response)
    return response


@login_required
def export_products_pdf(request):
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="Envanter_Raporu.pdf"'
    
  
    font_dir = os.path.join(settings.BASE_DIR, 'templates', 'static', 'fonts')
    font_normal = os.path.join(font_dir, 'DejaVuSans.ttf')
    font_bold = os.path.join(font_dir, 'DejaVuSans-Bold.ttf')
    
    try:
        pdfmetrics.registerFont(TTFont('DejaVuSans', font_normal))
        pdfmetrics.registerFont(TTFont('DejaVuSans-Bold', font_bold))
        main_font = 'DejaVuSans'
        bold_font = 'DejaVuSans-Bold'
    except:
        main_font = 'Helvetica'
        bold_font = 'Helvetica-Bold'

    doc = SimpleDocTemplate(response, pagesize=A4, rightMargin=30, leftMargin=30, topMargin=30, bottomMargin=30)
    elements = []
    styles = getSampleStyleSheet()

    turkce_normal_style = ParagraphStyle(
        'TurkceNormal', 
        parent=styles['Normal'], 
        fontName=main_font, 
        fontSize=10, 
        spaceAfter=5
    )

    title_style = ParagraphStyle(
        'TitleStyle', parent=styles['Heading1'], fontName=bold_font, fontSize=16, 
        alignment=1,
        spaceAfter=10, textColor=colors.dodgerblue
    )

    elements.append(Paragraph("ENVANTER VE STOK RAPORU", title_style))
    elements.append(Spacer(1, 12))

    products = Product.objects.all()
    total_items = products.count()
    total_stock = products.aggregate(Sum('stock'))['stock__sum'] or 0
    
    elements.append(Paragraph(f"<b>Rapor Tarihi:</b> {timezone.now().strftime('%d.%m.%Y %H:%M')}", turkce_normal_style))
    elements.append(Paragraph(f"<b>Toplam Ürün Çeşidi:</b> {total_items}", turkce_normal_style))
    elements.append(Paragraph(f"<b>Toplam Stok Miktarı:</b> {total_stock}", turkce_normal_style))
    elements.append(Spacer(1, 20))

    data = [['Ürün Adı', 'Kategori', 'Fiyat (TL)', 'Stok', 'SKT']]
    
    for p in products:
        skt = p.expiration_date.strftime('%d.%m.%Y') if p.expiration_date else "-"
        data.append([
            p.name, 
            p.category.name if p.category else "Genel", 
            f"{p.price:,.2f}", 
            str(p.stock), 
            skt
        ])

    table_style = TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.dodgerblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, -1), main_font),
        ('FONTNAME', (0, 0), (-1, 0), bold_font),
        ('FONTSIZE', (0, 0), (-1, -1), 9),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.whitesmoke, colors.white])
    ])

    table = Table(data, colWidths=[180, 100, 80, 50, 90], repeatRows=1)
    table.setStyle(table_style)
    elements.append(table)
    
    def footer(canvas, doc):
        canvas.saveState()
        canvas.setFont(main_font, 8)
        canvas.drawString(30, 20, "Market ERP Solutions")
        canvas.drawRightString(565, 20, f"Sayfa {doc.page}")
        canvas.restoreState()

    doc.build(elements, onFirstPage=footer, onLaterPages=footer)
    return response

from django.http import JsonResponse
from .models import Product

def product_search_api(request):
    query = request.GET.get('q', '')
    products = Product.objects.filter(name__icontains=query)[:10]
    
    results = []
    for p in products:
        results.append({
            'id': p.id,
            'name': p.name,
            'price': float(p.price),
            'stock': p.stock,
            'category': p.category.name if p.category else "Genel"
        })
    
    return JsonResponse({'products': results})