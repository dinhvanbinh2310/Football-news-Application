import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/product_card.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_application_1/screens/cart_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/models/merchandise.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({Key? key}) : super(key: key);
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;
  String? _token;
  List<Merchandise> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/merchandise'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((json) => Merchandise.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load products';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
      _token = token;
    });
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    // Điều hướng theo index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductCategoryScreen(),
          ),
        );
        break;
      case 2:
        // Điều hướng đến màn hình khác (ví dụ: Hồ sơ)
        break;
    }
  }

  void _onLoginSuccess() {
    _checkLoginStatus();
  }

  // Hàm kiểm tra đăng nhập và thực hiện hành động
  Future<bool> _checkLoginAndProceed(Function action) async {
    if (!isLoggedIn) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      // Refresh trạng thái đăng nhập sau khi quay lại từ màn hình login
      await _checkLoginStatus();

      // Nếu đăng nhập thành công và có token
      if (isLoggedIn) {
        action();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần đăng nhập để thực hiện chức năng này'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    } else {
      // Đã đăng nhập, thực hiện hành động
      action();
      return true;
    }
  }

  void _handleAddToCart(
    String productName,
    String imageUrl,
    String price,
    String productId,
  ) {
    _checkLoginAndProceed(() {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final priceValue = double.parse(price.replaceAll('\$', ''));

      cartProvider.addItem({
        '_id': productId,
        'name': productName,
        'image': imageUrl,
        'price': priceValue,
      });
      print('Đã thêm $productId vào giỏ hàng');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm $productName vào giỏ hàng'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _handleBuyNow(
    String productName,
    String imageUrl,
    String price,
    String productId,
  ) {
    _checkLoginAndProceed(() {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final priceValue = double.parse(price.replaceAll('\$', ''));

      // Thêm sản phẩm vào giỏ hàng
      cartProvider.addItem({
        'name': productName,
        'image': imageUrl,
        'price': priceValue,
        '_id': productId,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavbar(
        title: "Danh mục sản phẩm",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: _onLoginSuccess,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      imageUrl:
                          product.image.isNotEmpty
                              ? product.image[0]
                              : 'assets/images/placeholder.jpg',
                      name: product.name,
                      price: '\$${product.price.toStringAsFixed(2)}',
                      onAddToCart:
                          () => _handleAddToCart(
                            product.name,
                            product.image.isNotEmpty
                                ? product.image[0]
                                : 'assets/images/placeholder.jpg',
                            '\$${product.price.toStringAsFixed(2)}',
                            product.id,
                          ),
                      onBuy:
                          () => _handleBuyNow(
                            product.name,
                            product.image.isNotEmpty
                                ? product.image[0]
                                : 'assets/images/placeholder.jpg',
                            '\$${product.price.toStringAsFixed(2)}',
                            product.id,
                          ),
                    );
                  },
                ),
              ),
      bottomNavigationBar: Navbar(currentIndex: currentIndex, onTap: onTap),
    );
  }
}
