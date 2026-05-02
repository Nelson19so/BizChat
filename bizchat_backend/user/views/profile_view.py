from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model
from ..serializer import UserProfileSerializer, UserSerializer
from rest_framework.response import Response

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
        # partial=True is the magic that makes it a PATCH
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
