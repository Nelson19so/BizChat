from rest_framework import serializers
from .models import ChatRoom, Message, StatusPost
from user.serializer import UserSerializer
from user.models import CustomUser


class RoomListSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()
    last_message = serializers.SerializerMethodField()
    last_message_time = serializers.SerializerMethodField()

    class Meta:
        model = ChatRoom
        fields = ["id", "user", "last_message", "last_message_time"]

    def get_user(self, obj):
        request_user = self.context["request"].user
        other_user = obj.participants.exclude(id=request_user.id).first()
        return UserSerializer(other_user).data if other_user else None

    def get_last_message(self, obj):
        msg = obj.messages.order_by("-created_at").first()
        return msg.text if msg else ""

    def get_last_message_time(self, obj):
        msg = obj.messages.order_by("-created_at").first()
        return msg.created_at if msg else None


class MessageSerializer(serializers.ModelSerializer):

    class Meta:
        model = Message
        fields = ["id", "room", "sender", "text", "created_at"]


class StatusPostSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()

    class Meta:
        model = StatusPost
        fields = ['id', 'user', 'caption', 'image', 'video', 'posted_at']

    def get_user(self, obj):
        return UserSerializer(obj).data if obj else None


class CreateRoomSerializer(serializers.Serializer):
    user_id = serializers.IntegerField()

    def validate_user_id(self, value):
        try:
            user = CustomUser.objects.get(id=value)
        except CustomUser.DoesNotExist:
            raise serializers.ValidationError("User does not exist")

        request = self.context['request']

        if user == request.user:
            raise serializers.ValidationError(
                "You cannot create chat with yourself"
            )

        return value