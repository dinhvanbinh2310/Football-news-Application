import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/components/news_widget.dart';
import 'package:flutter_application_1/components/arrival_widget.dart';
import 'package:flutter_application_1/components/dashboard_drawer.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // ✅ Thêm scaffoldKey
  bool isLoggedIn = false; // ✅ Thêm trạng thái đăng nhập
  String? _token; // Biến lưu token
  @override
  void initState() {
    super.initState();
    _getToken(); // Gọi hàm lấy token ngay khi HomeScreen được khởi tạo
  }

  void _onLoginSuccess() {
    setState(() {
      isLoggedIn = false; // ✅ Cập nhật trạng thái khi đăng nhập thành công
    });
  }

  int _selectedIndex = 0; // Trạng thái tab hiện tại

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      print("Token trong home: $token");
      setState(() {
        isLoggedIn = true;
        _token = token;
      });
    } else {
      print("Không tìm thấy token! Điều hướng về LoginScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Chuyển về Login nếu không có token
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ✅ Gán scaffoldKey vào Scaffold
      appBar: TopNavbar(
        title: 'Ứng dụng Flutter',
        scaffoldKey: _scaffoldKey,
        onLoginSuccess:
            _onLoginSuccess, // ✅ Truyền callback xử lý đăng nhập thành công
      ), // ✅ Truyền scaffoldKey vào TopNavbar
      drawer: DashboardDrawer(token: _token), // ✅ Thêm menu Dashboard sổ dọc
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ), // ✅ Tạo khoảng cách ngang cho đẹp hơn
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsWidget(), // Hiển thị danh sách tin tức
            SizedBox(height: 20),
            Text(
              "New Arrivals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            NewArrivals(), // Hiển thị sản phẩm mới
            SizedBox(height: 20),
            Center(
              child: Text(
                _selectedIndex == 0
                    ? 'Trang chủ'
                    : _selectedIndex == 1
                    ? 'Tìm kiếm'
                    : 'Hồ sơ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
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
