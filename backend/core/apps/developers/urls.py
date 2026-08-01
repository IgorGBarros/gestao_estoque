from django.urls import path

from . import views

urlpatterns = [
    path('register/', views.register, name='developer_register'),
    path('login/', views.login, name='developer_login'),
    path('me/', views.me, name='developer_me'),
    path('dashboard/', views.dashboard, name='developer_dashboard'),
]