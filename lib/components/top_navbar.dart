import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    setState(() {
      token = storedToken;
      isLoggedIn = storedToken != null;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      isLoggedIn = false;
    });
    widget.onLoginSuccess();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã đăng xuất thành công')));
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
        if (isLoggedIn)
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Túi của bạn đang trống!')),
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
                _checkLoginStatus();
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
