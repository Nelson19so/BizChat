from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from rest_framework import status

from django.contrib.auth import get_user_model
from django.urls import reverse

from user.models import UserProfile

# Create your tests here.

User = get_user_model()


class ProfileApiTestCase(APITestCase):

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

        # User account url reverse
        self.user_profile_url = reverse("my-accounts")
        self.user_profile_patch_url = reverse("my-accounts-profile")
        self.public_profile_url = reverse("public-user", args=[self.user2_id])
        self.public_profile_not_found_url = reverse("public-user", args=[5])
        self.public_profile_userid_isme_url = reverse("public-user", args=[self.user1_id])


    # Test case 1
    def test_unauthenticated_user_profile(self):
        self.client.credentials()

        user_profile_response = self.client.get(
            self.user_profile_url
        )

        self.assertEqual(
            user_profile_response.status_code,
            status.HTTP_401_UNAUTHORIZED
        )

    # Test case 2
    def test_authenticated_user_profile(self):
        user_profile_response = self.client.get(
            self.user_profile_url
        )

        self.assertEqual(
            user_profile_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 3
    def test_authenticated_user_profile_patch(self):
        user_profile_response = self.client.get(
            self.user_profile_url
        )

        self.assertEqual(
            user_profile_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 3
    def test_authenticated_user_profile_patch(self):
        data = {
            "state": "Hong Kong",
            "zip_code": "3719",
            "country": "China",
        }

        user_profile_patch_response = self.client.patch(
            self.user_profile_patch_url,
            data=data,
            format="json"
        )

        self.assertEqual(
            user_profile_patch_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 4
    def test_authenticated_public_profile(self):
        public_profile_response = self.client.get(
            self.public_profile_url,
        )

        self.assertEqual(
            public_profile_response.status_code,
            status.HTTP_200_OK
        )

    # Test case 5
    def test_authenticated_public_profile_not_found(self):
        public_profile_response = self.client.get(
            self.public_profile_not_found_url,
        )

        self.assertEqual(
            public_profile_response.status_code,
            status.HTTP_404_NOT_FOUND
        )

    # Test case 6
    def test_authenticated_public_profile_isme(self):
        public_profile_response = self.client.get(
            self.public_profile_userid_isme_url,
        )

        self.assertEqual(
            public_profile_response.status_code,
            status.HTTP_400_BAD_REQUEST
        )        
