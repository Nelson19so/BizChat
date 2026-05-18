from django.urls import path
from .views import MessageListView, UserRoomsView

urlpatterns = [
    path("my-rooms/", UserRoomsView.as_view()),
    path("messages/", MessageListView.as_view()),
]