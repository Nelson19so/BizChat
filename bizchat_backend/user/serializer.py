from rest_framework import serializers
from .models import CustomUser
from django.contrib.auth.password_validation import validate_password
from django.db import IntegrityError, transaction
from django.core.exceptions import ValidationError as DjangoValidationError
from django.contrib.auth import authenticate
import re


NAME_REGEX = re.compile(r"^[A-Za-z]+$")

def validate_name(value, field_name="name"):
    value = value.strip()

    if not value:
        raise serializers.ValidationError(f"{field_name.capitalize()} is required.")

    if len(value) < 2:
        raise serializers.ValidationError(f"{field_name.capitalize()} must be at least 2 characters.")

    if len(value) > 30:
        raise serializers.ValidationError(f"{field_name.capitalize()} must be less than 30 characters.")

    if not NAME_REGEX.match(value):
        raise serializers.ValidationError(
            f"{field_name.capitalize()} can only contain letters."
        )

    return value

class UserRegistrationSerializer(serializers.ModelSerializer):
    """
    Handles user registration with email-based authentication.
    """
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ('email', 'first_name', 'last_name', 'password', 'confirm_password')


    def validate_email(self, value):
        value = value.lower()
        if CustomUser.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with that email already exists.")
        return value

    def validate_first_name(self, value):
        return validate_name(value, "first name")

    def validate_last_name(self, value):
        return validate_name(value, "last name")

    def validate(self, attrs):
        password = attrs.get("password")
        confirm_password = attrs.get("confirm_password")

        if password != confirm_password:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        
        try:
            validate_password(password)
        except DjangoValidationError as e:
            messages = []
            for msg in e.messages:
                if "too short" in msg.lower():
                    messages.append("Password must be at least 8 characters long.")
                elif "too common" in msg.lower():
                    messages.append("Password is too common. Choose a stronger password.")
                elif "numeric" in msg.lower():
                    messages.append("Password cannot be entirely numeric.")
                else:
                    messages.append(msg)

            raise serializers.ValidationError({
                "password": messages
            })

        return attrs
    
    def create(self, validated_data):
        validated_data.pop('confirm_password', None)

        try:
            with transaction.atomic():
                return CustomUser.objects.create_user(**validated_data)
        except IntegrityError:
            raise serializers.ValidationError({
                "email": "A user with that email already exists."
            })


class UserLoginSerializer(serializers.Serializer):
    """
    Handles user login with email and password.
    """
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get("email").lower()
        password = attrs.get("password")

        if not email or not password:
            raise serializers.ValidationError(
                "Email and password are required."
            )

        user = authenticate(email=email, password=password)

        if not user:
            raise serializers.ValidationError(
                "Invalid email or password."
            )

        if not user.is_active:
            raise serializers.ValidationError(
                "This account is inactive."
            )

        attrs["user"] = user
        return attrs
