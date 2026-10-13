from django.core.cache   import cache

from .cache_keys import ChatRoomsCacheKeys


class ChatRoomCacheMixin:
    """
    Chat Rooms Mixin for cache to get and set cache room key
    With a helper for setting the requested user
    """

    def get_cache_helper(self):
        if self.request and self.request.user.is_authenticated:
            return ChatRoomsCacheKeys(
                user_id=self.request.user.id
            )

        return None
    

    # Get cache for room
    def get_room_cache(self):
        helper = self.get_cache_helper()

        if not helper:
            return None

        return cache.get(helper.chat_room_user_cache_key())

    # Set cache for room
    def set_room_cache(self, data, timeout=900):
        helper = self.get_cache_helper()

        if helper:
            cache.set(
                helper.chat_room_user_cache_key(), data, timeout=timeout
            )


    # Get cache for room with message
    def get_message_room_cache(self):
        helper = self.get_cache_helper()

        if not helper:
            return None

        return cache.get(helper.chat_room_user_cache_key())

    # Set cache for room with message
    def set_message_room_cache(self, data, timeout=900):
        helper = self.get_cache_helper()

        if helper:
            cache.set(
                helper.chat_room_user_cache_key(), data, timeout=timeout
            )