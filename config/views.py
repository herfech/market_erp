from django.shortcuts import render, redirect
from django.shortcuts import get_object_or_404
from django.contrib.auth.forms import UserCreationForm
from django.urls import reverse_lazy
from django.views import generic
from products.models import Product
from sales.models import Sale
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required

def home(request):
    return render(request, 'layout/home.html')

def dashboard(request):
    if not request.user.is_authenticated:
        return redirect('home')
        
    total_products = Product.objects.count()
    today_sales = Sale.objects.count()
    
    context = {
        'total_products': total_products,
        'today_sales': today_sales,
        'all_products': Product.objects.all(),
    }
    return render(request, 'sales/dashboard.html', context)

class SignUpView(generic.CreateView):
    form_class = UserCreationForm
    success_url = reverse_lazy('login')
    template_name = 'accounts/signup.html'


@login_required
def quick_sale(request):
    if request.method == 'POST':
        product_id = request.POST.get('product_id')
        product = get_object_or_404(Product, id=product_id)
        
        if product.stock > 0:
            product.stock -= 1
            product.save()
            Sale.objects.create(product=product, quantity=1, total_price=product.price)
            
            return JsonResponse({
                'status': 'success', 
                'message': f'{product.name} satıldı!',
                'new_stock': product.stock
            })
        else:
            return JsonResponse({'status': 'error', 'message': 'Stok yetersiz!'}, status=400)
    return JsonResponse({'status': 'error', 'message': 'Geçersiz istek.'}, status=400)