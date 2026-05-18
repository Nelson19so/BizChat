from channels.middleware import BaseMiddleware
from channels.db import database_sync_to_async


class JWTAuthMiddleware(BaseMiddleware):

    async def __call__(self, scope, receive, send):

        from rest_framework_simplejwt.tokens import UntypedToken
        from jwt import decode as jwt_decode
        from django.conf import settings
        from django.contrib.auth import get_user_model

        User = get_user_model()

        query_string = scope["query_string"].decode()

        token = None

        if "token=" in query_string:
            token = query_string.split("token=")[1]

        if token:
            try:
                UntypedToken(token)

                decoded_data = jwt_decode(
                    token,
                    settings.SECRET_KEY,
                    algorithms=["HS256"]
                )

                user = await self.get_user(
                    User,
                    decoded_data["user_id"]
                )

                scope["user"] = user

            except Exception as e:
                print("JWT ERROR:", e)
                scope["user"] = None

        else:
            scope["user"] = None

        return await super().__call__(scope, receive, send)

    @database_sync_to_async
    def get_user(self, User, user_id):
        return User.objects.get(id=user_id)