from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100)

class Product(models.Model):
    barcode = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=100)