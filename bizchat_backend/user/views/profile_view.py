from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model
from ..serializer import UpdateProfileSerializer, UserSerializer
from rest_framework.response import Response
from rest_framework import status
from ..models import UserProfile

User = get_user_model()


class UserApiView(APIView):
    """User profile details"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if request.user.is_anonymous:
            return Response(
                {"error": "Authentication required"},
                status=status.HTTP_401_UNAUTHORIZED
            )

        serializer = UserSerializer(request.user)
        return Response(serializer.data)


class UserProfileApiView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)

        return Response(serializer.data)

    def patch(self, request):
        serializer = UpdateProfileSerializer(
            request.user.profile,
            data=request.data,
            partial=True,
        )

        serializer.is_valid(raise_exception=True)

        serializer.save()

        return Response(
            {
                "success": True,
                "message": "Profile updated successfully.",
                "user": UserSerializer(request.user).data,
            },
            status=status.HTTP_200_OK,
        )

class SearchUserByPhoneNumberApiView(APIView):
    """Search user by phone number"""
    permission_classes = [IsAuthenticated]

    def get(self, request, phone_number):
        phone_number = phone_number.strip()

        user_profile = UserProfile.objects.filter(
            phone_number=phone_number
        ).first()

        if not user_profile:
            return Response(
                {"details": "This user is not registered"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = UserSerializer(user_profile.user)

        return Response(serializer.data, status=status.HTTP_200_OK)


class PublicProfileApiView(APIView):
    """Public profile view for user"""

    def get(self, request, user_id):
        pub_user = User.objects.filter(id=user_id).first()

        if not pub_user:
            return Response(
                {"details": "This user is not registered"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = UserSerializer(pub_user)

        return Response(serializer.data, status=status.HTTP_200_OK)    
