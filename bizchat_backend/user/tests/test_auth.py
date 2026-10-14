from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from rest_framework import status

from django.contrib.auth import get_user_model
from django.urls import reverse


User = get_user_model()


class AuthApiTestCase(APITestCase):

    def setUp(self):
        self.user1 = User.objects.create_user(
            first_name="test", 
            last_name="user1",
            email="user1@gmail.com",
            password="password123"
        )
        self.user1_id = self.user1.id

        self.user2 = User.objects.create_user(
            first_name="test", 
            last_name="user2",
            email="user2@gmail.com", 
            password="password123"
        )
        self.user2_id = self.user2.id

        self.token = Token.objects.create(user=self.user1)
        self.client.credentials(
            HTTP_AUTHORIZATION='Token ' + self.token.key
        )

        self.register_user_url = reverse("register-user")
        self.login_user_url = reverse("login-user")
        self.logout_user_url = reverse("logout-user")
        self.delete_user_url = reverse("delete-myaccount")

        self.register_data = {
            "first_name": "test",
            "last_name": "user",
            "email": "testUser123@example.com",
            "password": "TestUser123!"
        }

    # Test case 1
    def test_try_register_while_authenticated(self):
        register_user_response = self.client.post(
            self.register_user_url,
            data=self.register_data,
            format="json"
        )

        self.assertEqual(
            register_user_response.status_code,
            status.HTTP_403_FORBIDDEN
        )

    # Test case 2
    def test_register_anonymous_user(self):
        # Set user credentials empty (Anonymous)
        self.client.credentials()

        register_user_response = self.client.post(
            self.register_user_url,
            data=self.register_data,
            format="json"
        )

        self.assertEqual(
            register_user_response.status_code,
            status.HTTP_201_CREATED
        )

    # Test case 3
    def test_login_anonymous_user(self):
        self.client.credentials()

        login_user_response = self.client.post(
            self.login_user_url,
            data={
                "email": "testUser123@example.com",
                "password": "TestUser123!",
            },
            format="json"
        )

        self.assertEqual(
            login_user_response.status_code,
            status.HTTP_200_OK
        )        

    # Test case 4
    def test_delete_authenticated_user_account(self):
        delete_auth_user_response = self.client.delete(
            self.delete_user_url,
        )

        self.assertEqual(
            delete_auth_user_response.status_code,
            status.HTTP_200_OK
        )
