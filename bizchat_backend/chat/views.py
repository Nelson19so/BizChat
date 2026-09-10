from rest_framework import generics
from .models import ChatRoom, Message, StatusPost
from .serializers import (
    RoomListSerializer, MessageSerializer, 
    StatusPostSerializer, CreateRoomSerializer
)
from rest_framework.views import APIView, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from user.models import CustomUser
from django.db.models import Q, Prefetch


User = get_user_model()


participant_prefetch = Prefetch(
    'participants',
    queryset=User.objects.only(
        "id", 
        "first_name", 
        "last_name", 
        "profile__profile_picture"
    )
)

messages_prefetch = Prefetch(
    "messages",
    queryset=Message.objects.order_by('-created_at')
)


class UserRoomsView(generics.ListAPIView):
    serializer_class = RoomListSerializer

    def get_queryset(self):
        return ChatRoom.objects.filter(
            participants=self.request.user
        ).prefetch_related(
            participant_prefetch, 
            messages_prefetch
        )


class UserRoomsWithChatView(generics.ListAPIView):
    serializer_class = RoomListSerializer

    def get_queryset(self):
        return ChatRoom.objects.filter(
            participants=self.request.user,
            messages__sender=self.request.user
        ).prefetch_related(
            participant_prefetch, 
            messages_prefetch
        ).distinct()


class SearchMyCustomersByNameView(generics.ListApiView):
    serializer_class = RoomListSerializer

    def get_queryset(self):
        search_input = self.request.query_params.get("search_name", '').split()
        name_part = search_input.split()

        if not name_part:
            return User.objects.none()

        base_queryset = User.objects.filter(
            chatroom__participants=self.request.user
        ).exclude(id=self.request.user.id).prefetch_related(
            participant_prefetch,
            messages_prefetch
        )

        if len(name_part) >= 2:
            first, last = name_part[0], name_part[-1]
            return base_queryset.objects.filter(
                first_name__icontains=first,
                last_name__icontains=last,
            ).distinct()

        single_name = name_part[0]
        return base_queryset.objects.filter(
            Q(first_name__icontains=single_name) |
            Q(last_name__icontains=single_name),
        ).distinct()


class MessageListView(generics.ListAPIView):
    serializer_class = MessageSerializer

    def get_queryset(self):
        room_id = self.request.query_params.get("room_id")
        
        return Message.objects.filter(
            room_id=room_id
        ).order_by(
            "created_at"
        ).select_related(
            "room", 
            "sender", 
            "sender__profile"
        ).prefetch_related(
            Prefetch(
                "room__participants",
                queryset=User.objects.select_related("profile").only(
                    "id", 
                    "first_name", 
                    "last_name", 
                    "profile__profile_picture"
                )
            )
        ).only(
            "id", 
            "room",
            "sender", 
            "text", 
            "created_at"

            # Related sender fields
            "sender__id",
            "sender__first_name",
            "sender__last_name",
            "sender__profile_id",
            "sender__profile__profile_picture"
        )


class StatusListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        status_posts = StatusPost.objects.filter(
            user__chatroom__participants=request.user
        ).select_related("user", "user__profile").only(
            'id', 'caption', 'image', 'video', 'posted_at',
            'user', "user__id", "user__first_name", "user__last_name", 
            "user__profile__profile_picture"
        )

        serializer = StatusPostSerializer(
            status_posts,
            many=True
        )

        return Response(serializer.data)  


class CreateOrGetRoomView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = CreateRoomSerializer(
            data=request.data,
            context={"request": request}
        )

        serializer.is_valid(raise_exception=True)

        other_user_id = serializer.validated_data['user_id']

        current_user = request.user

        other_user = get_object_or_404(
            CustomUser,
            id=other_user_id
        )

        # Check if room already exist
        room = (
            ChatRoom.objects
            .filter(participant=current_user)
            .filter(participant=other_user)
            .first()
        )

        # Create room if it doesn't exist
        if room is None:
            room = ChatRoom.objects.create()

            room.participants.add(
                current_user, 
                other_user
            )

        return Response(
            {
                "success": True,
                "room_id": room.id,
                "created_at": room.created_at,
            },
            status=status.HTTP_200_OK
        )
        