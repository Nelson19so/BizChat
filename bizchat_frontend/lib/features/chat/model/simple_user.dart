import 'package:bizchat_frontend/core/network/api_routes.dart';

class SimpleUser {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;

  SimpleUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    String? rawPicture = json['profile_picture'] as String?;

    // If the path is relative (e.g., starts with /media/), prepend the baseUrl
    if (rawPicture != null && !rawPicture.startsWith('http')) {
      // Ensure you handle duplicate or missing slashes carefully
      final base = ApiRoutes.baseUrl.endsWith('/')
          ? ApiRoutes.baseUrl.substring(0, ApiRoutes.baseUrl.length - 1)
          : ApiRoutes.baseUrl;
      final path = rawPicture.startsWith('/') ? rawPicture : '/$rawPicture';

      rawPicture = '$base$path';
    }
    return SimpleUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: rawPicture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
    };
  }
}