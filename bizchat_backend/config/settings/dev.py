from .base import *

DEBUG = True

# Allowed hosts for development
ALLOWED_HOSTS = []


# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer"
    }
}

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'


# Cors settings to allow requests from specified origins
CORS_ALLOW_ALL_ORIGINS = True