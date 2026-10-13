import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async
from datetime import timezone, datetime
from rest_framework.exceptions import PermissionDenied

class ChatConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.room_id = self.scope["url_route"]["kwargs"]["room_id"]
        self.group_name = f"room_{self.room_id}"

        await self.channel_layer.group_add(
            self.group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        data = json.loads(text_data)
        message = data["message"]
        user = self.scope.get("user_id")

        user_id = user.id
        now_iso = datetime.now(timezone.utc).isoformat()

        await self.save_message(user_id, message)

        await self.channel_layer.group_send(
            self.group_name,
            {
                "type": "chat_message",
                "message": message,
                "user_id": user_id,
                "timestamp": now_iso
            }
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps(event))

    @sync_to_async
    def save_message(self, user_id, message):
        from .models import Message, ChatRoom
        from django.contrib.auth import get_user_model

        User = get_user_model()

        if not user_id:
            raise ValueError(
                "Attempt to save message with no  user_id provided"
            )

        user_instance = User.objects.get(
            id=user_id
        )

        try:
            room_instance = ChatRoom.objects.get(
                id=self.room_id,
            )
        except ChatRoom.DoesNotExist:
            raise ValueError(
                "This room is not longer available"
            )

        is_member = room_instance.participants.filter(
            id=user_id
        )

        if not is_member:
            raise PermissionDenied(
                "You are not a member of this room."
            )
        
        return Message.objects.create(
            room=room_instance,
            sender=user_instance,
            text=message
        )
