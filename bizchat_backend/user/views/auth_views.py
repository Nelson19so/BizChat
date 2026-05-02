from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status, generics
from rest_framework_simplejwt.tokens import RefreshToken
from ..serializer import UserRegistrationSerializer, UserLoginSerializer, UserSerializer
from django.contrib.auth import get_user_model
from rest_framework.views import APIView

User = get_user_model()

# refresh token
def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class UserRegistrationView(generics.CreateAPIView):
    """
    API endpoint for user registration.
    """
    permission_classes = [AllowAny]
    serializer_class = UserRegistrationSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.save()

        # Generate JWT tokens
        tokens = get_tokens_for_user(user)

        return Response(
            {
                'success': True,
                'details': 'User registered successfully.',
                "user": {
                    "id": user.id,
                    "email": user.email,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                },
                "tokens": tokens
            },
            status=status.HTTP_201_CREATED
        )


class UserLoginView(generics.GenericAPIView):
    """
    User login view that authenticates email and password.
    Returns JWT access and refresh tokens on success.
    """
    serializer_class = UserLoginSerializer
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data["user"]

        # Generate JWT tokens
        tokens = get_tokens_for_user(user)

        user_data = UserSerializer(user).data

        return Response(
            {
                "success": True,
                "details": "Login successful.",
                "user": user_data,
                "tokens": tokens
            },
            status=status.HTTP_200_OK,
        )


class LogoutUserApiView(APIView):
    """
    Logout authenticated user
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')
            token = RefreshToken(refresh_token)

            token.blacklist()
            return Response(
                {"message": "Successfully logged out."}, status=status.HTTP_205_RESET_CONTENT
            )
        except Exception:
            return Response(
                {"error": "Invalid token."}, status=status.HTTP_400_BAD_REQUEST
            )    


class DeleteUserApiView(APIView):
    """
    Delete user accounts
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user

    def delete(self, request):
        user = request.user
        user.delete()
        return Response(
            {"message": "Account deleted successfully."}, 
            status=status.HTTP_204_NO_CONTENT
        )
