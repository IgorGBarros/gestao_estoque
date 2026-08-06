from django.urls import path
from .support_views import ajuda_list

urlpatterns = [
    path("", ajuda_list, name="ajuda-list"),
]
