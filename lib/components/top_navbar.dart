import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/admin_panel_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/cart_list_screen.dart';

class TopNavbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onLoginSuccess;

  TopNavbar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  _TopNavbarState createState() => _TopNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TopNavbarState extends State<TopNavbar> {
  bool isLoggedIn = false;
  String? token;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kiểm tra lại trạng thái mỗi khi widget được build lại
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final userRole = prefs.getString('role');

    if (mounted) {
      setState(() {
        token = storedToken;
        isLoggedIn = storedToken != null;
        isAdmin = userRole == 'admin';
        print(
          'Login status: isLoggedIn=$isLoggedIn, isAdmin=$isAdmin, role=$userRole',
        );
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    if (mounted) {
      setState(() {
        isLoggedIn = false;
        isAdmin = false;
      });
      widget.onLoginSuccess();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã đăng xuất thành công')));
    }
  }

  void _navigateToAdminPanel(BuildContext context) async {
    // Kiểm tra lại quyền admin trước khi chuyển trang
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role');

    if (userRole == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanelScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn không có quyền truy cập trang quản trị!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.blue,
      elevation: 4,
      leading: IconButton(
        icon: Icon(Icons.dashboard),
        onPressed: () {
          widget.scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        if (isLoggedIn && isAdmin)
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () => _navigateToAdminPanel(context),
            tooltip: 'Quản trị hệ thống',
          ),
        if (isLoggedIn)
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartListScreen()),
              );
            },
          )
        else
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );

              if (result == true) {
                await _checkLoginStatus();
                widget.onLoginSuccess();
              }
            },
            child: Text(
              "Đăng nhập",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(width: 8),
        if (isLoggedIn)
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Đăng xuất',
          ),
      ],
    );
  }
}
