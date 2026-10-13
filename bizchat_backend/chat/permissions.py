# Chat permissions

from rest_framework.permissions import BasePermission

class isChatRoomMember(BasePermission):
    """
    Custom permission to only allow members of a chatroom to 
    to access objects with that room 
    """

    def has_permission(self, request, view):
        return bool(
            request.user and request.user.is_authenticated
        )

    def has_object_permission(self, request, view, obj):
        room = obj.room

        return room.participants.filter(
            id=request.user.id
        ).exist()