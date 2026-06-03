class Profile {
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final String address;
  final String state;
  final String zipCode;
  final String country;
  final String phoneNumber;
  final DateTime createdAt;

  Profile({
    this.profilePicture,
    this.dateOfBirth,
    required this.address,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profilePicture: json['profile_picture'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      address: json['address'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      country: json['country'] as String,
      phoneNumber: json['phone_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}