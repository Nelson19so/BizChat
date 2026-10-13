from django.db.models.signals import post_save
from django.dispatch import receiver
from django.core.cache   import cache

from config.cache.cache_keys import ChatRoomsCacheKeys

from .models import Message, ChatRoom


@receiver(post_save, sender=ChatRoom)
def invalidate_chatroom_cache(sender, instance, created, **kwargs):
    if created:
        user_id = getattr(instance, "participants__id", None)

        if user_id:
            cache_keys = ChatRoomsCacheKeys(
                user_id=user_id
            )

            cache.delete(
                cache_keys.chat_room_user_cache_key()
            )


@receiver(post_save, sender=Message)
def invalidate_message_cache(sender, instance, created, **kwargs):
    if created:
        chat_room = getattr(instance, "room", None)

        if chat_room:
            participants = chat_room.participants.all()

            for user in participants:
                cache_key_msg_room = ChatRoomsCacheKeys(
                    user_id=user.id
                )

                cache.delete(
                    cache_key_msg_room.message_chat_room_user_cache_key()
                )