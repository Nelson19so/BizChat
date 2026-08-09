import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/features/auth/models/api_response.dart';
import 'package:dio/dio.dart';

class ProfileApiResponse {
  final Dio _dio;

  ProfileApiResponse(this._dio);

  Future<ApiResponse> updateUserProfile({
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
      final Map<String, dynamic> fields = {
        "first_name": firstName,
        "last_name": lastName,
        "email": profileEmail,
        "date_of_birth": birthDate,
        "address": address,
        "state": profileState,
        "zip_code": zipCode,
        "country": profileCountry,
        "phone_number": phoneNumber,
      };

      // Convert the map into FormData
      final formData = FormData.fromMap(fields);

      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            "profile_picture",
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.patch(
        ApiRoutes.updateUser,
        data: formData,
      );

      if (response.data == null) {
        throw Exception("Server returned empty response");
      }

      final bool isSuccess = response.data['success'] as bool? ?? false;

      if (!isSuccess) {
        throw Exception(response.data['details'] ?? "Profile Update failed");
      }

      return ApiResponse.fromJson(response.data);
    } on DioException catch(error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }
}