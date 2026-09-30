from rest_framework.views   import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth    import get_user_model
from ..serializer           import UpdateProfileSerializer, UserSerializer
from rest_framework.response import Response
from rest_framework         import status


User = get_user_model()


user_api_only = (
    "id",
    "first_name",
    "last_name",
    "email",
    "is_active",
    "is_staff",

    "profile",
    "profile__id",
    "profile__profile_picture",
    "profile__verified",
    "profile__date_of_birth",
    "profile__address",
    "address__zip_code",
    "profile__state",
    "profile__country",
    "profile__phone_number",
    "profile__created_at",

    "statuses",
    "statuses__id",
    "statuses__count",
    "statuses__latest_status_time",
)

class UserApiView(APIView):
    """User profile details"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if request.user.is_anonymous:
            return Response(
                {"error": "Authentication required"},
                status=status.HTTP_401_UNAUTHORIZED
            )

        user = User.objects.filter(
            id=request.user.id
        ).select_related(
            "profile",
            "statuses",
        ).only(
            user_api_only
        ).first()

        serializer = UserSerializer(user)
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


class PublicProfileApiView(APIView):
    """Public profile view for user"""

    def get(self, request, user_id):
        pub_user = User.objects.filter(
            id=user_id
        ).select_related(
            "profile",
            "statuses",
        ).only(
            user_api_only
        ).first()

        if not pub_user:
            return Response(
                {"details": "This user is not registered"},
                status=status.HTTP_404_NOT_FOUND
            )

        if pub_user == request.user:
            return Response(
                {"details": "Authenticated User"},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = UserSerializer(pub_user)

        return Response(serializer.data, status=status.HTTP_200_OK)    
