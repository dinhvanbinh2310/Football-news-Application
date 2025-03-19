import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  final String token; // Nhận token từ màn hình trước đó

  const ChangePasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      _showMessage('Mật khẩu mới không trùng khớp', false);
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/auth/update-password'), // Cập nhật đường dẫn API
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}', // Gửi token để xác thực
      },
      body: jsonEncode({
        'oldPassword': oldPasswordController.text,
        'newPassword': newPasswordController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      _showMessage('Cập nhật mật khẩu thành công', true);
    } else {
      final responseData = jsonDecode(response.body);
      _showMessage(responseData['message'] ?? 'Có lỗi xảy ra', false);
    }
  }

  void _showMessage(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi Mật Khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu cũ'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _changePassword,
              child: isLoading ? const CircularProgressIndicator() : const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
