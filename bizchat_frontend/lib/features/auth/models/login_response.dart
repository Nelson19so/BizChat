import 'package:bizchat_frontend/features/auth/models/user.dart';

class LoginResponse {
  final bool success;
  final String details;
  final User user;

  LoginResponse({
    required this.success,
    required this.details,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      details: json['details'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}