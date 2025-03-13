import 'package:flutter/material.dart';

class TopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopNavbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.blue,
      elevation: 4, // Đổ bóng nhẹ
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_bag), // Biểu tượng túi
          onPressed: () {
            // Xử lý sự kiện khi nhấn vào icon túi
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Túi của bạn đang trống!')));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
