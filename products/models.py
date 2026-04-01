from django.db import models
from datetime import date

class Category(models.Model):
    name = models.CharField(max_length=100)
    
    class Meta:
        ordering = ['name']
        verbose_name = "Kategori"
        verbose_name_plural = "Kategoriler"

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=100)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.IntegerField()

    expiration_date = models.DateField(null=True, blank=True, verbose_name="Son Kullanma Tarihi")

    class Meta:
        ordering = ['name']
        verbose_name = "Ürün"
        verbose_name_plural = "Ürünler"

    def __str__(self):
        return self.name