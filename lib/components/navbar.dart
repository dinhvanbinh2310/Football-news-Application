import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/chat_screen.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Bắt buộc để màu nền hoạt động
      backgroundColor: Colors.black, // Nền tối
      selectedItemColor: Colors.white, // Màu icon được chọn
      unselectedItemColor: Colors.grey, // Màu icon không được chọn
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 3) {
          showModalBottomSheet(
            context: context,
            builder: (context) => ChatScreen(),
          );
        } else {
          onTap(index);
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Hỗ trợ',
        ), // Nút Chat
      ],
    );
  }
}
