import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  static const _refresh = "refresh";
  static const _access = "access";

  Future<void> saveToken(String access, String refresh) async {
    await _storage.write(key: _access, value: access);
    await _storage.write(key: _refresh, value: refresh);
  }

  Future<void> saveAccessToken(String access) async {
    await _storage.write(key: _access, value: access);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _access);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: _refresh);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }
}

/// Provider
final tokenStorageProvider = Provider((ref) {
  return TokenStorage();
});