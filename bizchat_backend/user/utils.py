from rest_framework.exceptions import ValidationError
from .models import UserProfile
import re

# Name feld validators
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


def validate_phone_number(value, instance=None):
    value = value.strip()

    if not value.isdigit():
        raise ValidationError("Phone number must contain only digits.")

    if len(value) < 10:
        raise ValidationError("Phone number is too short.")

    qs = UserProfile.objects.filter(phone_number=value)

    if instance:
        qs = qs.exclude(pk=instance.pk)

    if qs.exists():
        raise ValidationError("Phone number is already registered.")

    return value
