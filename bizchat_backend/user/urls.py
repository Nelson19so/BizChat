from django.urls import path
from .views.auth_views import UserRegistrationView, UserLoginView
from .views.profile_view import UserProfileApiView

urlpatterns = [
    # User auth endpoints
    path('register/', UserRegistrationView.as_view(), name='register_user'),
    path('login/', UserLoginView.as_view(), name='login_user'),
    
    # User profile endpoints
    path('profile/', UserProfileApiView.as_view(), name='user_profile')
]
