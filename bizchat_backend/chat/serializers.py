from rest_framework import serializers
from django.contrib.auth.models import User
from .models import ChatRoom, Message
from user.serializer import UserSerializer


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
        fields = "__all__"