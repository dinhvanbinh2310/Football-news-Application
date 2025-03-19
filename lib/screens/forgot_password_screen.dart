import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reset_password_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  void sendResetCode() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập email")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/auth/forgot-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Chuyển sang màn hình nhập mã xác nhận
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: Không thể gửi mã xác nhận")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quên Mật Khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nhập email của bạn để nhận mã xác nhận",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendResetCode,
              child: Text("Gửi mã xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}
