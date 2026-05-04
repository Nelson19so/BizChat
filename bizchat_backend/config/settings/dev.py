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
CORS_ALLOW_ALL_ORIGINS = True