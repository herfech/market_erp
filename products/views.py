from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from .models import Product
from .forms import ProductForm
import openpyxl
from django.http import HttpResponse
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle


def product_list(request):
    products = Product.objects.all()
    return render(request, 'products/inventory.html', {'products': products})

@login_required 
def product_add(request):
    if request.method == 'POST':
        form = ProductForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('product_list')
    else:
        form = ProductForm()
    return render(request, 'products/product_form.html', {'form': form})


def export_products_excel(request):
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Envanter Raporu"
    headers = ['Ürün Adı', 'Kategori', 'Fiyat (TL)', 'Stok Miktarı']
    ws.append(headers)

    products = Product.objects.all()
    for product in products:
        ws.append([
            product.name, 
            product.category.name, 
            product.price, 
            product.stock
        ])

    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    )
    response['Content-Disposition'] = 'attachment; filename="Envanter_Raporu.xlsx"'
    
    wb.save(response)
    return response


def export_products_pdf(request):
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="Envanter_Raporu.pdf"'

    doc = SimpleDocTemplate(response, pagesize=A4)
    elements = []

    data = [['Urun Adi', 'Kategori', 'Fiyat (TL)', 'Stok']]
    products = Product.objects.all()
    
    for p in products:
        data.append([p.name, p.category.name, str(p.price), str(p.stock)])

    style = TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.dodgerblue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('GRID', (0, 0), (-1, -1), 1, colors.grey)
    ])

    table = Table(data)
    table.setStyle(style)
    elements.append(table)
    
    doc.build(elements)
    return response