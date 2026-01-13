from django.urls import path
from .views import UserRegistrationView, UserLoginView

urlpatterns = [
    # User registration and login endpoints
    path('register/', UserRegistrationView.as_view(), name='register_user'),
    path('login/', UserLoginView.as_view(), name='login_user'),
]
