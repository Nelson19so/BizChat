from rest_framework.views   import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth    import get_user_model
from ..serializer           import UpdateProfileSerializer, UserSerializer
from rest_framework.response import Response
from rest_framework         import status
from django.db.models       import Prefetch
from chat.models            import StatusPost


User = get_user_model()


user_queryset = User.objects.select_related(
    "profile",
).prefetch_related(
    Prefetch(
        "statuses",
        queryset=StatusPost.objects.only(
            "id",
            "posted_at",
        )
    )
).only(
    "id",
    "first_name",
    "last_name",
    "email",
    "is_active",
    "is_staff",

    "profile",
    "profile__id",
    "profile__profile_picture",
    "profile__date_of_birth",
    "profile__address",
    "profile__zip_code",
    "profile__state",
    "profile__country",
    "profile__phone_number",
    "profile__created_at",
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

        user = user_queryset.filter(
            id=request.user.id
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
        pub_user = user_queryset.filter(
            id=user_id
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
