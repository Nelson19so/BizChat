import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:bizchat_frontend/features/auth/models/login_response.dart';
import 'package:bizchat_frontend/features/auth/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// STATE
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final String? error;
  final User? user;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.token,
    this.error,
    this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    String? error,
    User? user,
    bool clearError = false,
    bool clearUser = false,
    bool clearToken = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token,
      error: error,
      user: user,
    );
  }
}

/// CONTROLLER
class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref, this.dio) : super(AuthState.initial());

  final Ref ref;
  final Dio dio;

  /// LOGIN
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, user: null);

    try {
      final storage = ref.read(tokenStorageProvider);

      final response = await dio.post(
        ApiRoutes.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data != null && response.data["success"] == true) {
        final tokens = response.data["tokens"];

        final data = Map<String, dynamic>.from(response.data);
        final loginResponse = LoginResponse.fromJson(data);

        if (tokens != null) {
          final access = tokens['access'] ?? '';
          final refresh = tokens['refresh'] ?? '';

          // Save tokens securely
          await storage.saveToken(access, refresh);

          state = state.copyWith(
            isLoading: false,
            isLoggedIn: true,
            user: loginResponse.user
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: "Authentication tokens missing from server response.",
          );
        }
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorHelper.getErrorMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ErrorHelper.getErrorMessage(e),
      );
    }
  }

  /// REGISTER
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final storage = ref.read(tokenStorageProvider);

      final response = await dio.post(
        ApiRoutes.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        },
      );

      if (response.data != null && response.data["success"] == true) {
        final tokens = response.data["tokens"];

        final data = Map<String, dynamic>.from(response.data);
        final loginResponse = LoginResponse.fromJson(data);

        if (tokens != null) {
          final access = tokens['access'] ?? '';
          final refresh = tokens['refresh'] ?? '';

          // Save tokens securely
          await storage.saveToken(refresh, access);

          state = state.copyWith(
              isLoading: false,
              user: loginResponse.user
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: "Authentication tokens missing from server response.",
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// AUTO LOGIN (on app start)
  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true);

    final storage = ref.read(tokenStorageProvider);

    final access = await storage.getAccessToken();
    final refresh = await storage.getRefreshToken();

    if (access != null && refresh != null) {
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        token: access,
      );
    } else {
      state = AuthState.initial();
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    final storage = ref.read(tokenStorageProvider);

    await storage.clearToken();

    state = AuthState.initial();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// PROVIDER
final dioProvider = Provider<Dio>((ref) => Dio());

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final dio = ref.watch(dioProvider);
  final controller = AuthController(ref, dio);

  controller.checkAuth();

  return controller;
});
