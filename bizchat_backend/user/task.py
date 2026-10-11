from celery import shared_task
from django.contrib.auth import get_user_model
from django.utils import timezone

from .models import UserProfile

User = get_user_model()

@shared_task
def verify_user_account_task(profile_id):
    try:
        user_profile = UserProfile.objects.get(id=profile_id)

        user_profile.is_verified == True
        user_profile.profile_completed_at = timezone.now()
        user_profile.save()
    except UserProfile.DoesNotExist:
        return
    