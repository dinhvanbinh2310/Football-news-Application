import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl =
      'http://localhost:3000/chat/ask'; // Thay localhost bằng IP nếu gọi từ mobile device

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
        final data = jsonDecode(response.body);
        return data['message']; // Đọc từ key "message"
      } else {
        return 'Server Error: ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
