from rest_framework.test import APITestCase
from rest_framework import status
from rest_framework.authtoken.models import Token

from django.contrib.auth import get_user_model
from django.urls import reverse

from .models import ChatRoom

from user.models import UserProfile


User = get_user_model()


class ChatRoomApiTestCase(APITestCase):

    def setUp(self):
        self.user1 = User.objects.create_user(
            first_name="test", 
            last_name="user1",
            email="user1@gmail.com", 
            password="password123"
        )

        self.user2 = User.objects.create_user(
            first_name="test", 
            last_name="user2",
            email="user2@gmail.com", 
            password="password123"
        )

        self.user1_profile, created = UserProfile.objects.update_or_create(
            user=self.user1,
            defaults={"phone_number": "0812345679"},
        )

        self.user2_profile, created = UserProfile.objects.update_or_create(
            user=self.user2,
            defaults={"phone_number": "0812345678"},
        )

        self.token = Token.objects.create(user=self.user1)
        self.client.credentials(
            HTTP_AUTHORIZATION='Token ' + self.token.key
        )

        self.room1 = (
            ChatRoom.objects.create()
            .participants.set([self.user1])
        )

        # Room reversed url
        self.room_url = reverse("rooms-url")
        self.room_imessage_url = reverse("rooms-message-url")

        # Search Room reversed url
        self.search_room_username_url = reverse("search-username")
        self.search_room_phone_number_url = reverse("search-accounts")

    # Test case 1
    def test_unauthenticated_cannot_list_room(self):
        self.client.credentials()
        response = self.client.get(self.room_url)
        self.assertEqual(
            response.status_code, 
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 2
    def test_unauthenticated_cannot_list_imessage_room(self):
        self.client.credentials()
        response = self.client.get(self.room_imessage_url)
        self.assertEqual(
            response.status_code, 
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 3
    def test_authenticated_user_can_list_room(self):
        room_response = self.client.get(self.room_url)

        self.assertEqual(
            room_response.status_code, 
            status.HTTP_200_OK
        )

    # Test case 4
    def test_authenticated_user_can_list_imessage_room(self):
        imessage_room_response = self.client.get(self.room_imessage_url)

        self.assertEqual(
            imessage_room_response.status_code, 
            status.HTTP_200_OK
        )

    # Test case 5
    def test_unauthenticated_chatroom_username_search(self):
        self.client.credentials()
        query_params = {"search_name": "Test User"}

        chatroom_username_search_response = self.client.get(
            self.search_room_username_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_username_search_response.status_code,
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 6
    def test_authenticated_chatroom_username_search(self):
        query_params = {"search_name": "Test User"}

        chatroom_username_search_response = self.client.get(
            self.search_room_username_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_username_search_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 7
    def test_empty_chatroom_username_search_query(self):
        chatroom_username_search_response = self.client.get(
            self.search_room_username_url,
        )

        self.assertEqual(
            chatroom_username_search_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )

    # Test case 8
    def test_authenticated_chatroom_phone_number_search_exist(self):
        query_params = {"phone_number": "0812345678"}

        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_200_OK
        )        

    # Test case 9
    def test_authenticated_chatroom_phone_number_search_myself(self):
        query_params = {"phone_number": "0812345679"}

        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )   

    # Test case 10
    def test_authenticated_chatroom_phone_number_search_none(self):
        query_params = {"phone_number": "08012345670"}

        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_404_NOT_FOUND
        )

    # Test case 11
    def test_authenticated_chatroom_phone_number_search_no_query_params(self):
        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )   