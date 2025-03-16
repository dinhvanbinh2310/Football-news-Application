import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/components/news_widget.dart';
import 'package:flutter_application_1/components/arrival_widget.dart';
import 'package:flutter_application_1/screens/chat_screen.dart';

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
      body: SingleChildScrollView(
        // Bọc nội dung để tránh overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsWidget(), // Hiển thị danh sách tin tức
            SizedBox(height: 20), // Khoảng cách dưới NewsWidget
            Text(
              "New Arrivals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            SizedBox(
              // Đặt chiều cao cố định để tránh lỗi cuộn trong ListView
              height: 250, // Điều chỉnh theo nội dung của NewArrivalsWidget
              child: NewArrivalsWidget(),
            ),
            SizedBox(height: 20),
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
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
