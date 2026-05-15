from rest_framework import generics
from .models import ChatRoom, Message
from .serializers import RoomListSerializer, MessageSerializer


class UserRoomsView(generics.ListAPIView):
    serializer_class = RoomListSerializer

    def get_queryset(self):
        return ChatRoom.objects.filter(
            participants=self.request.user
        ).prefetch_related("participants", "messages")


class MessageListView(generics.ListAPIView):
    serializer_class = MessageSerializer

    def get_queryset(self):
        room_id = self.request.query_params.get("room_id")
        return Message.objects.filter(
            room_id=room_id
        ).order_by("created_at")