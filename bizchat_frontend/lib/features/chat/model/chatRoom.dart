import 'package:bizchat_frontend/features/settings/model/user.dart';

class ChatRoomModel {
  final int id;
  final User? user;
  final String lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomModel({
    required this.id,
    this.user,
    required this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as int,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      lastMessage: json['last_message'] as String? ?? '',
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
    };
  }
}