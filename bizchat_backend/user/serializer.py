from rest_framework import serializers
from .models import CustomUser, UserProfile
from django.contrib.auth.password_validation import validate_password
from django.db import IntegrityError, transaction
from django.core.exceptions import ValidationError as DjangoValidationError
from django.contrib.auth import authenticate
from .utils import validate_name, validate_phone_number
from datetime import date, timedelta
from django.utils import timezone


class UserSerializer(serializers.ModelSerializer):
    profile = serializers.SerializerMethodField()
    statuses = serializers.SerializerMethodField()

    class Meta:
        model = CustomUser
        fields = (
            'id', 
            'email', 
            'first_name',
            'last_name', 
            'is_active', 
            'is_staff',
            'profile',
            'statuses',
        )
        read_only_fields = ('id',)

    def get_statuses(self, obj):
        status = obj.statuses.all()

        if status.exists():
            return {
                "has_status": True,
                "count": obj.statuses.count(),
                "latest_status_time": obj.statuses.latest("posted_at").posted_at
            }

        return {"has_status": False}

    def get_profile(self, obj):
        profile = getattr(obj, 'profile', None)

        if not profile:
            return {
                "is_profile_filled": False,
                "verified": False
            }  

        is_verified = False
        
        if profile.profile_completed_at:
            one_day_passed = timezone.now() >= (profile.profile_completed_at + timedelta(days=1))
            
            if one_day_passed:
                is_verified = True
                if not profile.is_verified:
                    profile.is_verified = True
                    profile.save(update_fields=['is_verified'])    

        return {
            "profile_picture": profile.profile_picture.url if profile.profile_picture else None,
            "date_of_birth": profile.date_of_birth,
            "address": profile.address,
            "state": profile.state,
            "zip_code": profile.zip_code,
            "country": profile.country,
            "phone_number": profile.phone_number,
            "created_at": profile.created_at,
            "verified": is_verified,
        }


class UserRegistrationSerializer(serializers.ModelSerializer):
    """Handles user registration with email-based authentication."""
    first_name = serializers.CharField(
        required=True,
        error_messages={
            "required": "First name is required.",
            "blank": "First name cannot be empty."
        }
    )

    last_name = serializers.CharField(
        required=True,
        error_messages={
            "required": "Last name is required.",
            "blank": "Last name cannot be empty."
        }
    )
    password = serializers.CharField(write_only=True)
    # confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = (
            'email', 'first_name', 'last_name', 'password', 
            # 'confirm_password'
        )

    def validate_email(self, value):
        value = value.lower().strip()
        
        if CustomUser.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists.")
        return value

    def validate_first_name(self, value):
        return validate_name(value, "first name")

    def validate_last_name(self, value):
        return validate_name(value, "last name")

    def validate(self, attrs):
        password = attrs.get("password")
        # confirm_password = attrs.get("confirm_password")

        # if password != confirm_password:
        #     raise serializers.ValidationError({"password": "Password fields didn't match."})
        
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
        # validated_data.pop('confirm_password', None)

        try:
            with transaction.atomic():
                return CustomUser.objects.create_user(**validated_data)
        except IntegrityError:
            raise serializers.ValidationError({
                "email": "Email already exists."
            })


class UserLoginSerializer(serializers.Serializer):
    """Handles user login with email and password."""
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get("email").lower()
        password = attrs.get("password")

        if not email or not password:
            raise serializers.ValidationError({
                "details": "Email and password are required."
            })

        user = authenticate(email=email, password=password)

        if not user:
            raise serializers.ValidationError({
                "details": "Invalid email or password."
            })

        if not user.is_active:
            raise serializers.ValidationError({
                "details": "This account is inactive."
            })

        attrs["user"] = user
        return attrs


class UpdateProfileSerializer(serializers.ModelSerializer):
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    email = serializers.EmailField(required=False)

    class Meta:
        model = UserProfile
        fields = [
            "first_name",
            "last_name",
            "email",
            "profile_picture",
            "date_of_birth",
            "address",
            "state",
            "zip_code",
            "country",
            "phone_number",
        ]

    def validate_date_of_birth(self, value):
        if value and value.date() > date.today():
            raise serializers.ValidationError("Date of birth cannot be in the future.")
        return value

    def validate_phone_number(self, value):
        if value and not value.isdigit():
            raise serializers.ValidationError("Phone number must contain only digits.")
        if value and len(value) < 10:
            raise serializers.ValidationError("Phone number is too short.")
        
        queryset = UserProfile.objects.filter(phone_number=value)
        
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError("Phone number is registered.")
            
        return value

    def validate_zip_code(self, value):
        if not value.isdigit() or len(value) != 4:
            raise serializers.ValidationError("Zip code must be exactly 4 digits.")
        return value

    def validate(self, attrs):
        country = attrs.get('country')
        state = attrs.get('state')

        if country and country.lower() and not state:
            raise serializers.ValidationError({
                "state": "State is required for addresses in a country"
            })

        return attrs    

    def update(self, instance, validated_data):
        user = instance.user

        # Update User model fields
        user.first_name = validated_data.get("first_name", user.first_name)
        user.last_name = validated_data.get("last_name", user.last_name)
        user.email = validated_data.get("email", user.email)
        user.save()

        # Update Profile model fields (Includes profile_picture)
        instance.profile_picture = validated_data.get("profile_picture", instance.profile_picture)
        instance.date_of_birth = validated_data.get("date_of_birth", instance.date_of_birth)
        instance.address = validated_data.get("address", instance.address)
        instance.state = validated_data.get("state", instance.state)
        instance.zip_code = validated_data.get("zip_code", instance.zip_code)
        instance.country = validated_data.get("country", instance.country)
        instance.phone_number = validated_data.get("phone_number", instance.phone_number)

        instance.save()
        return instance
