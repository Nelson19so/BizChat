from rest_framework         import generics
from rest_framework.views   import APIView, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from django.contrib.auth import get_user_model
from django.shortcuts    import get_object_or_404
from django.db.models    import Q, Prefetch

from .models import ChatRoom, Message, StatusPost, UserChatRoomSearchHistory
from .serializers   import (
    RoomListSerializer, MessageSerializer, StatusPostSerializer, 
    CreateRoomSerializer, SimpleUserSerializer
)

from user.models import CustomUser, UserProfile
from config.cache.cache_mixins import ChatRoomCacheMixin

from typing import Tuple, Optional


User = get_user_model()


# Room Participant (user) Prefetch 
participant_prefetch = Prefetch(
    'participants',
    queryset=User.objects.only(
        "id", 
        "first_name", 
        "last_name", 
        "profile__profile_picture"
    )
)

# Message Prefetch
messages_prefetch = Prefetch(
    "messages",
    queryset=Message.objects.only(
        "id",
        "text",
        "created_at"
    ).order_by('-created_at')
)


# Get or create user search history for user search
def get_or_create_user_search(user_id: Optional[int] = None) -> Optional[
        Tuple["UserChatRoomSearchHistory", bool]
    ]:
    if user_id:
        user_search, created = UserChatRoomSearchHistory.objects.get_or_create(
            user_id=user_id
        )

        return user_search


class UserRoomsView(ChatRoomCacheMixin, generics.ListAPIView):
    '''
    User Chat Room with Cache and database optimization
    This View filters rooms where user is active
    '''
    serializer_class = RoomListSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user_id = self.request.user.id

        queryset: Optional[str] = self.get_room_cache()

        if not queryset:
            queryset = (
                ChatRoom.objects.filter(
                    participants__id=user_id
                )
                .prefetch_related(
                    participant_prefetch, 
                    messages_prefetch
                )
                .distinct()
            )

            self.set_room_cache(
                data=queryset, timeout=8200
            )

        return queryset


class UserRoomsWithChatView(ChatRoomCacheMixin, generics.ListAPIView):
    '''
    User Chat Room with Cache and database optimization
    This View filters user rooms with Chat a Message
    '''
    serializer_class = RoomListSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user_id = self.request.user.id

        queryset = self.get_message_room_cache()

        if not queryset:
            queryset = ChatRoom.objects.filter(
                participants__id=user_id,
            ).prefetch_related(
                participant_prefetch,
                messages_prefetch
            ).distinct()

            # Set Chat room for user
            self.set_message_room_cache(
                data=queryset, timeout=8200
            )

        return queryset


class SearchMyCustomersByNameView(generics.ListAPIView):
    serializer_class = SimpleUserSerializer
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs) -> Response:
        search_input = request.query_params.get("search_name", '')

        if not search_input:
            return Response(
                {"details": "search Name parameter is required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        return super().get(request, *args, **kwargs)

    def get_queryset(self):
        search_input = self.request.query_params.get("search_name", '')    
    
        name_part = search_input.split()

        if not name_part:
            User.objects.none()

        base_queryset = User.objects.filter(
            chatroom__participants=self.request.user
        ).exclude(id=self.request.user.id).prefetch_related(
            participant_prefetch,
            messages_prefetch
        )

        if len(name_part) >= 2:
            first, last = name_part[0], name_part[1]
            queryset = base_queryset.filter(
                first_name__icontains=first,
                last_name__icontains=last,
            ).distinct()

        else:
            single_name = name_part[0]
            queryset = base_queryset.filter(
                Q(first_name__icontains=single_name) |
                Q(last_name__icontains=single_name),
            ).distinct()

        if queryset:
            # Create a User search history
            UserChatRoomSearchHistory.objects.get_or_create(
                user=queryset
            )    

        return queryset


class SearchUserByPhoneNumberApiView(APIView):
    """Search user by phone number"""
    permission_classes = [IsAuthenticated]

    def get(self, request) -> Response:
        search_input: Optional[int] = request.query_params.get("phone_number")

        if not search_input or not search_input.strip():
            return Response(
                {"details": "Phone Number parameter is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        phone_number: Optional[int] = search_input.strip()

        is_authenticated_user = UserProfile.objects.filter(
            user=request.user,
            phone_number=phone_number
        ).values_list(
            "phone_number", flat=True
        )

        if is_authenticated_user.exists():
            return Response(
                {"details": "You cannot add yourself"},
                status=status.HTTP_400_BAD_REQUEST
            )

        user_profile = (
            User.objects.filter(
                profile__phone_number=phone_number
            ).exclude(
                id=request.user.id
            ).select_related(
                "profile",
            ).only(
                "id",
                "first_name",
                "last_name",

                "profile__id",
                "profile__phone_number",
                "profile__profile_picture",
            )
            .distinct()
            .first()
        )

        if not user_profile:
            return Response(
                {"details": "No user was found"},
                status=status.HTTP_404_NOT_FOUND
            )

        # Get or create user search history
        get_or_create_user_search(user_id=user_profile.id)

        serializer = SimpleUserSerializer(user_profile)

        return Response(serializer.data, status=status.HTTP_200_OK)


class MessageListView(generics.ListAPIView):
    serializer_class = MessageSerializer
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs) -> Response:
        room_id: int | None = request.query_params.get("room_id")

        response: Response = super().get(request, *args, **kwargs)

        if not room_id:
            return Response(
                {"details": "room id parameter is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        room = ChatRoom.objects.filter(
            id=room_id,
            participants=request.user
        )

        if not room:
            return Response(
                {"details": "You are not a member of this room"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        return response

    def get_queryset(self):
        room_id: Optional[int] = self.request.query_params.get("room_id")
        
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
                queryset=User.objects.select_related(
                    "profile"
                ).only(
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
            "created_at",

            # Related sender fields
            "sender__id",
            "sender__first_name",
            "sender__last_name",
            "sender__profile__id",
            "sender__profile__profile_picture"
        )


class StatusListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs) -> Response:
        status_posts = StatusPost.objects.filter(
            user__chatroom__participants=request.user
        ).select_related(
            "user", 
            "user__profile"
        ).only(
            'id', 
            'caption', 
            'image', 
            'video', 
            'posted_at', 

            # User fields
            'user', 
            "user__id", 
            "user__first_name", 
            "user__last_name", 
            "user__profile__profile_picture",
        )

        serializer = StatusPostSerializer(
            status_posts,
            many=True
        )

        return Response(serializer.data, status=status.HTTP_200_OK)  


class CreateOrGetRoomView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request) -> Response:
        serializer = CreateRoomSerializer(
            data=request.data,
            context={"request": request}
        )

        serializer.is_valid(raise_exception=True)

        other_user_id: Optional[int] = serializer.validated_data['user_id']
        current_user = request.user

        other_user = get_object_or_404(
            CustomUser,
            id=other_user_id
        )

        # Check if room already exist
        room = (
            ChatRoom.objects
            .filter(participants=current_user)
            .filter(participants=other_user)
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
            },
            status=status.HTTP_200_OK
        )
