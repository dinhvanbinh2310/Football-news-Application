import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

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
      return jsonDecode(response.body);
    } else {
      throw Exception("Đăng nhập thất bại! Lỗi: ${response.body}");
    }
  }
}
