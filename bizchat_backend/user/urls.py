from django.urls import path
from .views.auth_views import (
    UserRegistrationView, 
    UserLoginView, 
    LogoutUserApiView, 
    DeleteUserApiView
)
from .views.profile_view import UserApiView, UserProfileApiView, SearchUserByPhoneNumberApiView
from rest_framework_simplejwt.views import TokenRefreshView


urlpatterns = [
    # User auth endpoints
    path('register/', UserRegistrationView.as_view(), name='register_user'),
    path('login/', UserLoginView.as_view(), name='login_user'),
    path('logout/', LogoutUserApiView.as_view(), name='logout_user'),
    path('delete_myaccount/', DeleteUserApiView.as_view(), name='delete_myaccount'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # User details/profile endpoints
    path('me/', UserApiView.as_view(), name='my_accounts'),
    path('profile/', UserProfileApiView.as_view(), name='my_accounts_profile'),
    path(
        'search/<str:phone_number>/', SearchUserByPhoneNumberApiView.as_view(),
        name='search_accounts'
    ),
]
