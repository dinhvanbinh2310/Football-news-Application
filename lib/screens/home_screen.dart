import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/components/news_widget.dart';
import 'package:flutter_application_1/components/arrival_widget.dart';
import 'package:flutter_application_1/components/dashboard_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;
  String? _token;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  void _onLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
      _token = token;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopNavbar(
        title: 'Ứng dụng Flutter',
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: _onLoginSuccess,
      ),
      drawer: DashboardDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsWidget(),
            SizedBox(height: 20),
            Text(
              "New Arrivals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            NewArrivals(),
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
