import 'package:bizchat_frontend/features/settings/data/profile_api_response.dart';
import 'package:bizchat_frontend/features/settings/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProfileControllerState {
  final bool isLoading;
  final String? error;
  final User? user;
  final String? success;

  ProfileControllerState({
    required this.isLoading,
    this.error,
    this.user,
    this.success
  });

  factory ProfileControllerState.initial() {
    return ProfileControllerState(
      isLoading: false,
      error: null,
      success: null,
    );
  }

  ProfileControllerState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? success,
  }) {
    return ProfileControllerState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      success: success,
    );
  }
}

class ProfileController extends StateNotifier<ProfileControllerState> {
  ProfileController(this.api) : super(ProfileControllerState.initial());

  final ProfileApiResponse api;

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String birthDate,
    required String profileState,
    required String zipCode,
    required String profileEmail,
    required String phoneNumber,
    required String address,
    required String profileCountry,
    String? imagePath,
  }) async {
    try {
      state = state.copyWith(
        error: null,
        success: null,
        isLoading: true,
      );

      final response = await api.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        profileState: profileState,
        zipCode: zipCode,
        profileEmail: profileEmail,
        phoneNumber: phoneNumber,
        address: address,
        profileCountry: profileCountry,
        imagePath: imagePath
      );

      if (response.success == true && response.details != null) {
        state = state.copyWith(
          user: response.user,
          isLoading: false,
          success: response.details,
        );
      }
    } catch (err) {
      state = state.copyWith(
        success: null,
        isLoading: false,
        error: err.toString(),
      );
    }
  }
}
