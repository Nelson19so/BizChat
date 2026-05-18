from django.db import models
from django.conf import settings

# Chat model

class ChatRoom(models.Model):
    participants = models.ManyToManyField("user.CustomUser", related_name="rooms")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Room {self.id}"


class Message(models.Model):
    room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name="messages")
    sender = models.ForeignKey("user.CustomUser", on_delete=models.CASCADE)

    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.text


class StatusPost(models.Model):
    user = models.ManyToManyField('user.CustomUser',)
    caption = models.CharField(max_length=100, blank=True, null=True)
    image = models.ImageField(upload_to='status_images/', blank=True, null=True)
    video = models.FileField(upload_to='status_videos/', blank=True, null=True)
    posted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user
