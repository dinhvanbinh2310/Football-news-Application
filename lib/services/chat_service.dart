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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data
            .toString(); // Hoặc thay đổi tùy theo format trả về từ NestJS
      } else {
        throw Exception('Failed to generate text');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
