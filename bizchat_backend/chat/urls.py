from django.urls import path
from .views import (
    MessageListView,    UserRoomsView, 
    StatusListView,     CreateOrGetRoomView, 
    UserRoomsWithChatView, SearchMyCustomersByNameView 
)

urlpatterns = [
    path('status_post/', StatusListView.as_view(), name='status-url'),

    # filters all chat
    path("chat_list/", UserRoomsView.as_view(), name='rooms-url'),

    # filters where the user user had a last message
    path("chat_list_imessage/", UserRoomsWithChatView.as_view(), name='rooms-message-url'),
    path("chat_list/messages/", MessageListView.as_view(), name='messages-url'),
    path('chat_list/create/', CreateOrGetRoomView.as_view(), name="get-or-create-room"),
    path('chat_list/SearchMyCustomersByNameView/', SearchMyCustomersByNameView.as_view(), name="search-username")
]
