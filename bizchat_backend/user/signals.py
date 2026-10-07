from django.db.models.signals import post_save
from django.dispatch import receiver
from django.db import transaction

from .models import CustomUser, UserProfile
from .task import verify_user_account_task

@receiver(post_save, sender=CustomUser)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)


@receiver(post_save, sender=UserProfile)
def verify_user_profile(sender, instance, created, **kwargs):
    if created:
        return

    if instance.is_verified == False and instance.verified_all_fields:
        transaction.on_commit(
            lambda: verify_user_account_task.apply_async(
                args=[instance.pk],
                countdown=86400
            )
        )

