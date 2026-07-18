from django.urls import path
from backend.core.ai.views import ChatAskView

urlpatterns = [
    path("ask/", ChatAskView.as_view(), name="chat-ask"),
]