from django.urls import path
from API import views

urlpatterns = [
    path("register/", views.register),
    path("login/", views.login),
    path("search/", views.search),]