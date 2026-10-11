import 'package:bizchat_frontend/features/chat/model/simple_user.dart';

class ChatRoomModel {
  final int id;
  final SimpleUser? participant;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomModel({
    required this.id,
    this.participant,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as int,
      participant: json['participant'] != null ? SimpleUser.fromJson(json['participant'] as Map<String, dynamic>) : null,
      lastMessage: json['last_message'] as String? ?? '',
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': participant,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
    };
  }
}
