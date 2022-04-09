from django.db import models

# Create your models here.
class User(models.Model):
    firstname = models.CharField("First Name", max_length=100)
    lastname = models.CharField("Last Name", max_length=100)
    email = models.EmailField("Email", max_length=100)
    password = models.CharField("Password", max_length=100)

    portfolio_value = models.FloatField("Portfolio Value", default=0.0)
    invested_value = models.FloatField("Invested Value", default=0.0)

    day_projected_value = models.FloatField("Day Projected Value", default=0.0)
    week_projected_value = models.FloatField("Week Projected Value", default=0.0)
    month_projected_value = models.FloatField("Month Projected Value", default=0.0)

    portfolio = models.TextField("Portfolio", default="")