import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // Đăng ký tài khoản
  static Future<Map<String, dynamic>> register(
    String email,
    String fullname,
    String password,
  ) async {
    final Uri url = Uri.parse('$baseUrl/user/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "fullname": fullname,
        "password": password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Đăng ký thất bại!");
    }
  }

  // Đăng nhập

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token không hợp lệ');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadString = utf8.decode(base64Url.decode(normalized));
    return json.decode(payloadString);
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final Uri url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("📡 API Response Code: ${response.statusCode}");
    print("📡 API Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("📡 API Response Data: $data");
      if (data.containsKey('access_token')) {
        final token = data['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Decode token để lấy role
        final payload = _parseJwt(token);
        final role = payload['role'] ?? 'user';
        await prefs.setString('role', role);

        print("✅ Login success: role=$role, token=$token");
      }

      return data;
    } else {
      throw Exception("Đăng nhập thất bại! Lỗi: ${response.body}");
    }
  }
}
