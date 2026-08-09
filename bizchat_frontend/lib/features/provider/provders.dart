import 'package:bizchat_frontend/core/network/dio_client.dart';
import 'package:bizchat_frontend/features/auth/controllers/auth_controller.dart';
import 'package:bizchat_frontend/features/auth/data/user_api_service.dart';
import 'package:bizchat_frontend/features/settings/controller/profile_controller.dart';
import 'package:bizchat_frontend/features/settings/data/profile_api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// PROVIDER

/// User/Auth providers
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final dio = ref.watch(dioClient);
  return UserApiService(dio);
});

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final api = ref.watch(userApiServiceProvider);
  final controller = AuthController(ref, api);

  controller.checkAuth();

  return controller;
});


/// Profile providers
final profileApiServiceProvider = Provider<ProfileApiResponse>((ref) {
  final dio = ref.watch(dioClient);
  return ProfileApiResponse(dio);
});

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileControllerState>((ref) {
  final api = ref.watch(profileApiServiceProvider);
  return ProfileController(api);
});