import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/checkout_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
      _token = token;
    });

    // Nếu chưa đăng nhập, hiển thị thông báo và điều hướng đến trang đăng nhập
    if (!isLoggedIn) {
      // Thực hiện sau khi build hoàn tất để tránh lỗi setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần đăng nhập để xem giỏ hàng'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ).then((_) {
          // Kiểm tra lại trạng thái đăng nhập sau khi quay lại từ trang đăng nhập
          _checkLoginStatus();
        });
      });
    }
  }

  void _onLoginSuccess() {
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: TopNavbar(
        title: "Giỏ hàng",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: _onLoginSuccess,
      ),
      body:
          !isLoggedIn
              ? const Center(
                child: Text(
                  'Vui lòng đăng nhập để xem giỏ hàng',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child:
                        cartItems.isEmpty
                            ? const Center(
                              child: Text(
                                'Giỏ hàng trống',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                            : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['image'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(item['name']),
                                    subtitle: Text('\$${item['price']}'),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => cartProvider.removeItem(index),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  if (isLoggedIn && cartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng cộng:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const CheckoutScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Thanh toán',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
    );
  }
}
