from .base import *

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

# Allowed hosts for production
ALLOWED_HOSTS = [".vercel.app", 'localhost', '127.0.0.1']

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME'),
        'USER': os.getenv('DB_USER'),
        'PASSWORD': os.getenv('DB_PASSWORD'),
        'HOST': os.getenv('DB_HOST'),
        'PORT': os.getenv('DB_PORT'),
    }
}

# Redis layer for Channels
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [(os.getenv('REDIS_HOST', 'localhost'), int(os.getenv('REDIS_PORT', 6379))),],
        },
    },
}

# Cors settings to allow requests from specified origins
CORS_ALLOWED_ORIGINS = []


# Static files (CSS, JavaScript, Images)
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
