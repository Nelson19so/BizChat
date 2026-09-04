from django.urls import path
from .views import MessageListView, UserRoomsView, StatusListView, CreateOrGetRoomView

urlpatterns = [
    path('status_post/', StatusListView.as_view(), name='status-url'),
    path("chat_list/", UserRoomsView.as_view(), name='rooms-url'),
    path("chat_list/messages/", MessageListView.as_view(), name='messages-url'),
    path('chat_list/create/', CreateOrGetRoomView.as_view(), name="get-or-create-room")
]
