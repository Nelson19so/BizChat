import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authservice {
  static const _storage = FlutterSecureStorage();
  static const _baseUrl = 'http://127.0.0.1:8000/user';

  // Register user + Auto-login
  Future<Map<String, dynamic>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await _storage.write(key: 'access', value: data['access']);
      await _storage.write(key: 'refresh', value: data['refresh']);
    }

    return {"statusCode": response.statusCode, "data": data};
  }

  // Check login status
  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'access');
    return token != null;
  }

  // Logout user
  Future<void> logout() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }

  // Get access token for authenticated requests
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access');
  }
}
