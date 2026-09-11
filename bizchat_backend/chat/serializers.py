from rest_framework import serializers
from .models import ChatRoom, Message, StatusPost
from user.serializer import SimpleUserSerializer
from user.models import CustomUser


class RoomListSerializer(serializers.ModelSerializer):
    participant = serializers.SerializerMethodField()
    last_message = serializers.SerializerMethodField()
    last_message_time = serializers.SerializerMethodField()

    class Meta:
        model = ChatRoom
        fields = ["id", "participant", "last_message", "last_message_time"]

    def get_participant(self, obj):
        request_user = self.context["request"].user
        all_participants = obj.participants.all()
        other_user = next((u for u in all_participants if u.id != request_user.id), None)
        return SimpleUserSerializer(other_user).data if other_user else None

    def get_last_message(self, obj):
        messages = obj.messages.all()
        msg = messages[0] if messages else None
        return msg.text if msg else ""

    def get_last_message_time(self, obj):
        messages = obj.messages.all()
        msg = messages[0] if messages else None
        return msg.created_at if msg else None


class MessageSerializer(serializers.ModelSerializer):
    sender = SimpleUserSerializer(read_only=True)
    room_dm = serializers.SerializerMethodField()

    class Meta:
        model = Message
        fields = ["id", "room", "room_dm", "sender", "text", "created_at"]

    def get_room_dm(self, obj):
        request = self.context.get("request")
        if not request or not request.user:
            return None

        room = obj.room
        if not room:
            return None

        all_participants = room.participants.all()

        other_user = next((u for u in all_participants if u.id != request.user.id), None)

        return SimpleUserSerializer(other_user, context=self.context).data if other_user else None


class StatusPostSerializer(serializers.ModelSerializer):
    user = SimpleUserSerializer(read_only=True)

    class Meta:
        model = StatusPost
        fields = ['id', 'user', 'caption', 'image', 'video', 'posted_at']


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