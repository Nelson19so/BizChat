import 'package:bizchat_frontend/core/network/api_routes.dart';

class Profile {
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final String? address;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? phoneNumber;
  final DateTime? createdAt;
  final bool? verified;

  Profile({
    this.profilePicture,
    this.dateOfBirth,
    required this.address,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.createdAt,
    required this.verified,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
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
    return Profile(
      profilePicture: rawPicture,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      address: json['address'] as String?,
      state: json['state'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      phoneNumber: json['phone_number'] as String?,
      verified: json['verified'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  factory Profile.empty() {
    return Profile(
      profilePicture: null,
      dateOfBirth: null,
      address: null,
      state: null,
      zipCode: null,
      country: null,
      phoneNumber: null,
      createdAt: null,
      verified: null,
    );
  }
}