import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/features/auth/models/api_response.dart';
import 'package:bizchat_frontend/features/auth/models/user.dart';
import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;

  UserApiService(this._dio);

  /// Get current user details api service
  Future<User> getUser() async {
    try {
      final response = await _dio.get(ApiRoutes.getUser);

      return User.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Login user api service
  Future<ApiResponse> loginUser({
    required String email,
    required String password
  }) async {
    try {
      final response = await _dio.post(
        ApiRoutes.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data == null) {
        throw Exception("Server returned empty response");
      }

      final bool isSuccess = response.data['success'] as bool? ?? false;

      if (!isSuccess) {
        throw Exception(response.data['details'] ?? "Login failed");
      }

      return ApiResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Register user api service
  Future<ApiResponse> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password
  }) async {
    try {
      final response = await _dio.post(
        ApiRoutes.register,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
      );

      return ApiResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Logout user api service
  Future<ApiResponse> logoutUser() async {
    try {
      final response  = await _dio.post(ApiRoutes.logoutUser);

      return ApiResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Delete user api service
  Future<ApiResponse> deleteUser() async {
    try {
      final response = await _dio.delete(ApiRoutes.deleteUser);

      return ApiResponse.fromJson(response.data);
    } on DioException catch(error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }
}