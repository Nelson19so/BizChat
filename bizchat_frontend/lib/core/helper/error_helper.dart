import 'package:dio/dio.dart';

class ErrorHelper {
  static String getErrorMessage(dynamic error) {
    try {
      // Dio errors
      if (error is DioException) {
        final data = error.response?.data;

        // Backend returned JSON
        if (data is Map<String, dynamic>) {
          return data['message']?.toString() ??
              data['details']?.toString() ??
              data['error']?.toString() ??
              data['email']?.toString() ??
              "Something went wrong";
        }

        // Backend returned plain text
        if (data is String) {
          return data;
        }

        // Timeout
        if (error.type == DioExceptionType.connectionTimeout) {
          return "Connection timeout";
        }

        // No internet
        if (error.type == DioExceptionType.connectionError) {
          return "No internet connection";
        }

        // Server timeout
        if (error.type == DioExceptionType.receiveTimeout) {
          return "Server took too long to respond";
        }

        return error.message ?? "Something went wrong";
      }

      // Other errors
      return error.toString();
    } catch (_) {
      return "Unexpected error occurred";
    }
  }
}