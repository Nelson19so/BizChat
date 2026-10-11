from urllib.parse import parse_qs
from channels.middleware import BaseMiddleware
from channels.db import database_sync_to_async
from django.conf import settings

class JWTAuthMiddleware(BaseMiddleware):

    async def __call__(self, scope, receive, send):
        from rest_framework_simplejwt.tokens import UntypedToken
        from jwt import decode as jwt_decode

        query_string = scope["query_string"].decode()
        query_params = parse_qs(query_string)
        token_list = query_params.get('token')

        token = token_list[0] if token_list else None
        user = None

        if token:
            try:
                UntypedToken(token)

                decoded_data = jwt_decode(
                    token,
                    settings.SECRET_KEY,
                    algorithms=["HS256"]
                )

                user_id = decoded_data.get("user_id")

                if user_id:
                    user = await self.get_user(
                        decoded_data["user_id"]
                    )
            except Exception as e:
                print("JWT ERROR:", e)
                scope["user_id"] = None
        
        scope["user_id"] = user if user else None
        return await super().__call__(scope, receive, send)

    @database_sync_to_async
    def get_user(self, user_id):
        from django.contrib.auth import get_user_model

        User = get_user_model()

        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            return None