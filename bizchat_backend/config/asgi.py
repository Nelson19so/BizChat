import os
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter

from chat.middleware import JWTAuthMiddleware

os.environ.setdefault(
    "DJANGO_SETTINGS_MODULE",
    "config.settings.dev"
)

django_asgi_app = get_asgi_application()


def websocket_application():
    import chat.routing
    return URLRouter(chat.routing.websocket_urlpatterns)


application = ProtocolTypeRouter({
    "http": django_asgi_app,

    "websocket": JWTAuthMiddleware(
        websocket_application()
    ),
})