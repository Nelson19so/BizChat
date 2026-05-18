from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model
from ..serializer import UserProfileSerializer, UserSerializer
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

    def get_object(self):
        return self.request.user.profile

    def get(self, request):
        """Retrieve profile data"""
        profile = self.get_object()
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    def put(self, request):
        """Full update: Requires all fields"""
        profile = self.get_object()
        serializer = UserProfileSerializer(profile, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request):
        """Partial update: Update only provided fields"""
        profile = self.get_object()
        partial=True
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


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
        user = User.objects.filter(id=user_id).first()

        if not user:
            return Response(
                {"details": "This user is not registered"},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = UserSerializer(user_profile.user)

        return Response(serializer.data, status=status.HTTP_200_OK)    
