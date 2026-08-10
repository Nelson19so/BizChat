from rest_framework import generics
from .models import ChatRoom, Message, StatusPost
from .serializers import RoomListSerializer, MessageSerializer, StatusPostSerializer
from rest_framework.views import APIView, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import get_user_model

User = get_user_model()


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


class StatusListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        chat_rooms = ChatRoom.objects.select_related(
            participants=request.user
        )

        users = User.objects.filter(
            chatroom__in=chat_rooms
        )

        status_posts = StatusPost.objects.filter(
            user__in=users
        )

        serializer = StatusPostSerializer(
            status_posts,
            many=True
        )

        return Response(serializer.data)  
