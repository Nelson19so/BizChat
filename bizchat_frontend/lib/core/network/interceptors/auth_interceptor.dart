import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage storage;
  final Dio dio;

  AuthInterceptor(this.storage, this.dio);

  bool _isRefreshing = false;
  final List<RequestOptions> _queue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.getAccessToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // 🚫 prevent infinite loop
    if (err.requestOptions.extra["retry"] == true) {
      return handler.next(err);
    }

    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) {
      await storage.clearToken();
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (_isRefreshing) {
      _queue.add(requestOptions);
      return;
    }

    _isRefreshing = true;

    try {
      final refreshDio = Dio(BaseOptions(
        baseUrl: ApiRoutes.baseUrl,
        headers: {"Content-Type": "application/json"},
      ));

      final response = await refreshDio.post(
        ApiRoutes.refreshToken,
        data: {"refresh": refreshToken},
      );

      final newAccess = response.data["access"];
      await storage.saveAccessToken(newAccess);

      // retry original request
      final opts = err.requestOptions;
      opts.headers["Authorization"] = "Bearer $newAccess";
      opts.extra["retry"] = true;

      final retryResponse = await dio.fetch(opts);

      // retry queue
      for (final req in _queue) {
        req.headers["Authorization"] = "Bearer $newAccess";
        req.extra["retry"] = true;
        dio.fetch(req);
      }

      _queue.clear();
      _isRefreshing = false;

      return handler.resolve(retryResponse);
    } catch (e) {
      _isRefreshing = false;
      _queue.clear();
      await storage.clearToken();
      return handler.next(err);
    }
  }
}