import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/change_password_screen.dart';

class DashboardDrawer extends StatelessWidget {
  final String? token;

  // ✅ Sửa constructor để nhận token từ HomeScreen
  const DashboardDrawer({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Dashboard',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context); // Đóng drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () {
              if (token != null) { // ✅ Kiểm tra token đã được truyền từ HomeScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(token: token!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vui lòng đăng nhập lại!")),
                );
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
