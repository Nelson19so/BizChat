from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.conf import settings

"""
Custom user manager
"""
class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('email address is required')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        return self.create_user(email, password, **extra_fields)

"""
Custom user model
"""
class CustomUser(AbstractUser):
    first_name = models.CharField(max_length=30, blank=False, null=False)
    last_name = models.CharField(max_length=30, blank=False, null=False)
    email = models.EmailField(unique=True, blank=False, null=False)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'
    
    def get_full_name(self):
        return f"{self.first_name} {self.last_name}"

    def __str__(self):
        return f'{self.email}'

"""
user profile model
"""
class UserProfile(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='profile'
    )
    profile_picture = models.ImageField(upload_to='avatar/', blank=True, null=True)
    date_of_birth = models.DateTimeField(null=True, blank=True),
    address = models.CharField(max_length=200, name=True, blank=True)
    state = models.CharField(max_length=200, null=True, blank=True)
    zip_code = models.IntegerField(max_length=4, null=False, blank=False)
    country = models.CharField(max_length=200, null=True, blank=True)
    phone_number = models.IntegerField(max_length=11, null=True, blank=True)
    