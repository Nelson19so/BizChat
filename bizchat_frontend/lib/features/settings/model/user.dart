import 'package:bizchat_frontend/features/settings/model/profile.dart';
import 'package:bizchat_frontend/features/auth/models/statuses.dart';

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final Profile profile;
  final Statuses statuses;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
    required this.profile,
    required this.statuses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isStaff: json['is_staff'] as bool? ?? false,
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
          : Profile.empty(),
      statuses: json['statuses'] != null
          ? Statuses.fromJson(json['statuses'] as Map<String, dynamic>)
          : Statuses.empty(),
    );
  }
}