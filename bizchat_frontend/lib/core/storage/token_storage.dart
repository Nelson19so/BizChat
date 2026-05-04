import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  static const _refresh = "refresh";
  static const _access = "access";

  Future<void> saveToken(String access, String refresh) async {
    await _storage.write(key: _refresh, value: refresh);
    await _storage.write(key: _access, value: access);
  }

  // Get access token for authenticated requests
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }
}

final tokenStorageProvider = Provider((ref) {
  return TokenStorage();
});