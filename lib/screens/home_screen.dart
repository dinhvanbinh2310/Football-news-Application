import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/components/news_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Lưu trạng thái tab hiện tại

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavbar(title: 'Ứng dụng Flutter'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NewsWidget(), // Hiển thị danh sách tin tức ở đầu trang
          SizedBox(
            height: 20,
          ), // Thêm khoảng cách giữa NewsWidget và nội dung bên dưới
          Center(
            child:
                _selectedIndex == 0
                    ? Text('Trang chủ')
                    : _selectedIndex == 1
                    ? Text('Tìm kiếm')
                    : Text('Hồ sơ'),
          ),
        ],
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
