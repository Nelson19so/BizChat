import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:bizchat_frontend/features/auth/data/user_api_service.dart';
import 'package:bizchat_frontend/features/settings/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// STATE
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final String? error;
  final User? user;
  final String? success;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.token,
    this.error,
    this.user,
    this.success
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
      error: null,
      success: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    String? error,
    User? user,
    String? success,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error,
      success: success,
    );
  }
}

/// CONTROLLER
class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref, this.api) : super(AuthState.initial());

  final Ref ref;
  final UserApiService api;

  /// LOGIN
  Future<void> login(String email, String password) async {
    try {
      final storage = ref.read(tokenStorageProvider);
      state = state.copyWith(
        isLoading: true,
        error: null,
        user: null,
        success: null
      );

      final loginResponse = await api.loginUser(email: email, password: password);

      if (loginResponse.tokens != null && loginResponse.success == true) {
        final access = loginResponse.tokens!.access;
        final refresh = loginResponse.tokens!.refresh;

        await storage.saveToken(access, refresh);

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: access,
          success: loginResponse.details,
          user: loginResponse.user,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        success: null
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
    try {
      final storage = ref.read(tokenStorageProvider);
      state = state.copyWith(
          isLoading: true,
          error: null,
          user: null,
          success: null
      );

      final loginResponse = await api.registerUser(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password
      );

      if (loginResponse.tokens != null && loginResponse.success == true) {
        final access = loginResponse.tokens!.access;
        final refresh = loginResponse.tokens!.refresh;

        await storage.saveToken(access, refresh);

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: access,
          success: loginResponse.details,
          user: loginResponse.user,
        );
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: e.toString(),
          success: null
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

  /// GET current user
  Future<void> getUser() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final fetchedUser = await api.getUser();

      state = state.copyWith(
        isLoading: false,
        user: fetchedUser,
      );
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: err.toString(),
      );
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      state = state.copyWith(
        error: null,
        isLoading: true,
      );

      final response = await api.logoutUser();

      final storage = ref.read(tokenStorageProvider);
      await storage.clearToken();

      state = AuthState.initial();

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        success: response.details
      );
    } catch(err) {
      state = state.copyWith(
        isLoading: false,
        error: err.toString(),
      );
    }
  }

  /// Delete user
  Future<void> deleteUser() async {
    try {
      state = state.copyWith(
        error: null,
        isLoading: true,
      );

      final response = await api.deleteUser();

      final storage = ref.read(tokenStorageProvider);
      await storage.clearToken();

      state = AuthState.initial();

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        success: response.details
      );
    } catch(err) {
      state = state.copyWith(
        isLoading: false,
        error: err.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
