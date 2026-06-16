import 'package:bizchat_frontend/features/auth/models/user.dart';

class AuthTokens {
  final String access;
  final String refresh;

  AuthTokens({required this.access, required this.refresh});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: json['access'] as String? ?? '',
      refresh: json['refresh'] as String? ?? '',
    );
  }
}

class ApiResponse {
  final bool? success;
  final String? details;
  final User? user;
  final AuthTokens? tokens;

  ApiResponse({
    this.success,
    this.details,
    this.user,
    this.tokens,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool?,
      details: json['details']?.toString() ??
          json['message']?.toString(),
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      tokens: json['tokens'] != null
        ? AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>)
        : null,
    );
  }
}