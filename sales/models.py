from django.db import models
from django.contrib.auth.models import User
from products.models import Product

class Category(models.Model):
    name = models.CharField(max_length=100, verbose_name="Kategori Adı")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Kategori"
        verbose_name_plural = "Kategoriler"

class Sale(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, verbose_name="Kasiyer") # NUEVO
    date = models.DateTimeField(auto_now_add=True, verbose_name="Satış Tarihi")
    total_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0, verbose_name="Toplam Tutar")
    payment_method = models.CharField(
        max_length=20, 
        choices=[('Nakit', 'Nakit'), ('Kart', 'Kredi Kartı')], 
        default='Nakit',
        verbose_name="Ödeme Yöntemi",
    )
    is_cancelled = models.BooleanField(default=False, verbose_name="İptal Edildi")

    def __str__(self):
        return f"Satış #{self.pk} - {self.user.username if self.user else 'Sistem'}"
    
    class Meta:
        verbose_name = "Satış"
        verbose_name_plural = "Satışlar"

class SaleDetail(models.Model):
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, verbose_name="Ürün")
    quantity = models.PositiveIntegerField(default=1, verbose_name="Adet")
    unit_price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Birim Fiyat")
    subtotal = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Ara Toplam")

    def save(self, *args, **kwargs):
        self.subtotal = self.unit_price * self.quantity
        super().save(*args, **kwargs)