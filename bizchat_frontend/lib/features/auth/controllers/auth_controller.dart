import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/core/network/dio_client.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// STATE
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isLoggedIn,
    this.token,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isLoggedIn: false,
      token: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      error: error,
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      final storage = ref.read(tokenStorageProvider);

      final response = await dio.post(
        ApiRoutes.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      // Replace with real backend response
      final access = response.data["token"]['access'];
      final refresh = response.data["token"]['refresh'];

      await storage.saveToken(refresh, access);

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        // token: token,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data.toString() ?? e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
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
      await dio.post(
        ApiRoutes.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        },
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// AUTO LOGIN (on app start)
  Future<void> checkAuth() async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.getAccessToken();

    if (token != null) {
      state = state.copyWith(
        isLoggedIn: true,
        token: token,
      );
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    final storage = ref.read(tokenStorageProvider);

    await storage.clearToken();

    state = AuthState.initial();
  }
}

/// PROVIDER
final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final dio = ref.read(dioProvider);
  final authController = AuthController(ref, dio);

  return authController;
});
