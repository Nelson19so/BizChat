from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model

User = get_user_model()


class UserProfileApiView(APIView):
    """
    User profile details
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if request.user.is_anonymous:
            return Response(
                {"error": "Authentication required"},
                status=status.HTTP_401_UNAUTHORIZED
            )
            
        serializer = UserSerializer(request.user)
        return Response(serializer.data)