from typing import Optional, Tuple

class ChatRoomsCacheKeys:

    def __init__(self, user_id):
        if not user_id:
            raise ValueError(
                "user_id is not provided for cache key"
            )

        self.user_id = user_id

    def chat_room_user_cache_key(self) -> str:
        return f"chat_room_user_{self.user_id}"
    
    def message_chat_room_user_cache_key(self) -> str:
        return f"message_chat_room_user_{self.user_id}"

    def get_all_cache_keys(self):
        return [
            self.chat_room_user_cache_key(),
            self.message_chat_room_user_cache_key,()
        ]
