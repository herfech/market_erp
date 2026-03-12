from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from products.models import Product
from sales.models import Sale
from django.contrib.auth.forms import UserCreationForm
from django.urls import reverse_lazy
from django.views import generic

@login_required
def dashboard(request):
    total_products = Product.objects.count()
    today_sales = Sale.objects.count()
    
    context = {
        'total_products': total_products,
        'today_sales': today_sales,
    }
    return render(request, 'dashboard.html', context)

class SignUpView(generic.CreateView):
    form_class = UserCreationForm
    success_url = reverse_lazy('login')
    template_name = 'accounts/signup.html'