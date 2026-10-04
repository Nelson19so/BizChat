import 'package:bizchat_frontend/features/chat/model/simple_user.dart';

class MessageModel {
  final int id;
  final SimpleUser? sender;
  final String? text;
  final DateTime? createdAt;

  MessageModel({
    required this.id,
    this.sender,
    this.text,
    this.createdAt
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      sender: json['sender'] != null ? SimpleUser.fromJson(json['sender'] as Map<String, dynamic>) : null,
      text: json['text'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'text': text,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

