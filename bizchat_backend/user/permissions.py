from rest_framework.permissions import BasePermission

class AuthPermission(BasePermission):

    def has_permission(self, request, view) -> bool:
        user: any = request.user

        return bool(
            user and user.is_anonymous and not user.is_authenticated
        )
