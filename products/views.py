from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required, user_passes_test
from .models import Product, Category
from .forms import ProductForm
import openpyxl
from django.http import HttpResponse
from django.contrib import messages
from django.utils import timezone
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle

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
            form.save()
            messages.success(request, 'Ürün başarıyla eklendi!')
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

    doc = SimpleDocTemplate(response, pagesize=A4)
    elements = []

    data = [['Urun Adi', 'Kategori', 'Fiyat (TL)', 'Stok', 'SKT']]
    products = Product.objects.all()
    
    for p in products:
        skt = p.expiration_date.strftime('%d.%m.%Y') if p.expiration_date else "-"
        data.append([p.name, p.category.name if p.category else "Genel", str(p.price), str(p.stock), skt])

    style = TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.dodgerblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('GRID', (0, 0), (-1, -1), 1, colors.grey)
    ])

    table = Table(data, colWidths=[150, 100, 80, 60, 90])
    table.setStyle(style)
    elements.append(table)
    
    doc.build(elements)
    return response