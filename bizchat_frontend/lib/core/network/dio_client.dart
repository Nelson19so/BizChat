import 'package:bizchat_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  late Dio dio;

  DioClient(TokenStorage storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://jsonplaceholder.typicode.com",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(tokenStorageProvider);
  final client = DioClient(storage);

  return client.dio;
});