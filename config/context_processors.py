from products.models import Product

def all_products_processor(request):
    if request.user.is_authenticated:
        return {'all_products': Product.objects.all()}
    return {'all_products': []}