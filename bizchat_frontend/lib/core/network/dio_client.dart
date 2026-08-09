import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClient = Provider<Dio>((ref) {
  final storage = ref.read(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiRoutes.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  dio.interceptors.add(AuthInterceptor(storage, dio));
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});
