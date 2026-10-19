from rest_framework.test import APITestCase
from rest_framework import status
from rest_framework.authtoken.models import Token

from django.contrib.auth import get_user_model
from django.urls import reverse

from chat.models import ChatRoom
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
        self.user1_profile, created = UserProfile.objects.update_or_create(
            user=self.user1,
            defaults={"phone_number": "0812345679"},
        )
        self.user1_id = self.user1.id

        self.user2 = User.objects.create_user(
            first_name="test", 
            last_name="user2",
            email="user2@gmail.com", 
            password="password123"
        )
        self.user2_profile, created = UserProfile.objects.update_or_create(
            user=self.user2,
            defaults={"phone_number": "0812345678"},
        )
        self.user2_id = self.user2.id

        self.token = Token.objects.create(user=self.user1)
        self.client.credentials(
            HTTP_AUTHORIZATION='Token ' + self.token.key
        )

        self.room1 = ChatRoom.objects.create()
        self.room1.participants.set([self.user1])
        self.filter_room_id = ChatRoom.objects.filter(
            id=self.room1.id
        ).values_list("id", flat=True).first()

        self.room2 = ChatRoom.objects.create()
        self.room2.participants.set([self.user2])
        self.filter_room2_id = ChatRoom.objects.filter(
            id=self.room2.id
        ).values_list("id", flat=True).first()

        # Room reversed url
        self.room_url: str = reverse("rooms-url")
        self.room_imessage_url: str = reverse("rooms-message-url")

        # Search Room reversed url
        self.search_room_username_url: str = reverse("search-username")
        self.search_room_phone_number_url: str = reverse("search-accounts")

        self.status_post_url: str = reverse("status-url")

        self.get_or_create_room_url: str = reverse("get-or-create-room")

        self.message_url: str = reverse("messages-url")


    # Chat Room Test Case
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


    # ChatRoom User Search Test Case
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
    def test_empty_chatroom_username_no_search_query(self):
        chatroom_username_search_response = self.client.get(
            self.search_room_username_url,
        )

        self.assertEqual(
            chatroom_username_search_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )

    # Test case 8
    def test_unauthenticated_chatroom_phone_number_search(self):
        self.client.credentials()

        query_params = {"phone_number": "0812345678"}

        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
            query_params=query_params,
            format="json"
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_401_UNAUTHORIZED
        )        

    # Test case 9
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

    # Test case 10
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

    # Test case 11
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

    # Test case 12
    def test_authenticated_chatroom_phone_number_search_no_query_params(self):
        chatroom_phone_number_search_response = self.client.get(
            self.search_room_phone_number_url,
        )

        self.assertEqual(
            chatroom_phone_number_search_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )


    # Status Post Test Case
    # Test Case 13
    def test_unauthenticated_user_status_post_list(self):
        self.client.credentials()

        status_post_response = self.client.get(
            self.status_post_url,
        )

        self.assertEqual(
            status_post_response.status_code,
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 14
    def test_authenticated_user_status_post_list(self):
        status_post_response = self.client.get(
            self.status_post_url,
        )

        self.assertEqual(
            status_post_response.status_code,
            status.HTTP_200_OK
        )


    # Get or Create Room for User
    # Test case 15
    def test_unauthenticated_get_or_create_room(self):
        self.client.credentials()

        data = {"user_id": self.user2_id}

        get_or_create_room_response = self.client.post(
            self.get_or_create_room_url,
            data=data,
            format="json"
        )

        self.assertEqual(
            get_or_create_room_response.status_code,
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 16
    def test_authenticated_get_or_create_room(self):
        data = {"user_id": self.user2_id}

        get_or_create_room_response = self.client.post(
            self.get_or_create_room_url,
            data=data,
            format="json"
        )

        self.assertEqual(
            get_or_create_room_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 17
    def test_authenticated_get_or_create_room_id_not_exist(self):
        data = {"user_id": "10"}

        get_or_create_room_response = self.client.post(
            self.get_or_create_room_url,
            data=data,
            format="json"
        )

        self.assertEqual(
            get_or_create_room_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )

    # Test case 18
    def test_authenticated_get_or_create_room_id_isme(self):
        data = {"user_id": self.user1_id}

        get_or_create_room_response = self.client.post(
            self.get_or_create_room_url,
            data=data,
            format="json"
        )

        self.assertEqual(
            get_or_create_room_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )


    # Message Test Case
    # Test case 19
    def test_unauthenticated_message_list(self):
        self.client.credentials()

        query_p = {"room_id": self.filter_room_id}

        message_response = self.client.get(
            self.message_url,
            query_params=query_p,
            format="json",
        )

        self.assertEqual(
            message_response.status_code, 
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 20
    def test_authenticated_message_list(self):
        query_p = {"room_id": self.filter_room_id}

        message_response = self.client.get(
            self.message_url,
            query_params=query_p,
            format="json",
        )

        self.assertEqual(
            message_response.status_code, 
            status.HTTP_200_OK
        )

    # Test case 21
    def test_authenticated_message_list_not_in_room(self):
        query_p = {"room_id": self.filter_room2_id}

        message_response = self.client.get(
            self.message_url,
            query_params=query_p,
            format="json",
        )

        self.assertEqual(
            message_response.status_code, 
            status.HTTP_403_FORBIDDEN
        )

    # Test case 22
    def test_authenticated_message_list_no_query_params(self):
        message_response = self.client.get(
            self.message_url,
        )

        self.assertEqual(
            message_response.status_code, 
            status.HTTP_400_BAD_REQUEST
        )
