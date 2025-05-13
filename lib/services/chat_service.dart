import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl =
      'http://10.0.2.2:3000/chat/ask'; // Nếu chạy trên mobile, thay localhost bằng IP

  Future<String> askChatbot(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic> && data.containsKey('message')) {
            return data['message'];
          } else {
            return 'Invalid JSON format: Missing "message" key';
          }
        } catch (e) {
          return '${response.body}';
        }
      } else {
        return 'Server Error: ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
