from django.urls import path
from .views import ChatAskView
from .support_views import conversations_list_create, conversation_detail, tutorial_videos, help_search

urlpatterns = [
    path("ask/", ChatAskView.as_view(), name="chat-ask"),
    path("support/conversations/", conversations_list_create, name="support-conversations"),
    path("support/conversations/<uuid:conversation_id>/", conversation_detail, name="support-conversation-detail"),
    path("videos/", tutorial_videos, name="tutorial-videos"),
    path("help-search/", help_search, name="help-search"),
]