from .base import *

# SECURITY WARNING: don't run with debug turned on in production!
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

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'


# Media filles (Avatar, images, files)
MEDIA_URL = '/media/'

MEDIA_ROOT = BASE_DIR / 'media'

# Cors settings to allow requests from specified origins
CORS_ALLOWED_ORIGINS = [
    "https://example.com",
    "https://sub.example.com",
    "http://localhost:8080",
    "http://127.0.0.1:9000",
]

