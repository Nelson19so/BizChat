from django.urls import path
from .views.auth_views import (
    UserRegistrationView, UserLoginView, 
    LogoutUserApiView, DeleteUserApiView
)
from .views.profile_view import (
    UserApiView, UserProfileApiView, 
    PublicProfileApiView,
)
from rest_framework_simplejwt.views import TokenRefreshView


urlpatterns = [
    # User auth endpoints
    path('register/', UserRegistrationView.as_view(), name='register-user'),
    path('login/', UserLoginView.as_view(), name='login-user'),
    path('logout/', LogoutUserApiView.as_view(), name='logout-user'),
    path('delete_myaccount/', DeleteUserApiView.as_view(), name='delete-myaccount'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token-refresh'),
    
    # User details/profile endpoints
    path('me/', UserApiView.as_view(), name='my-accounts'),
    path('profile/', UserProfileApiView.as_view(), name='my-accounts-profile'),
    path('public_user/<int:user_id>/', PublicProfileApiView.as_view(), name='public-user'),
]
