from django.urls import path
from .views import MessageListView, UserRoomsView, StatusListView

urlpatterns = [
    path("my_rooms/", UserRoomsView.as_view(), name='rooms_url'),
    path("messages/", MessageListView.as_view(), name='messages_url'),
    path('status_post/', StatusListView.as_view(), name='status_url'),
]
