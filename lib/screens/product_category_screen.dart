import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/product_card.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/components/top_navbar.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_application_1/screens/cart_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({Key? key}) : super(key: key);
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  int currentIndex = 0; // Khai báo currentIndex
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

  void _handleAddToCart(String productName, String imageUrl, String price) {
    _checkLoginAndProceed(() {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final priceValue = double.parse(price.replaceAll('\$', ''));

      cartProvider.addItem({
        'name': productName,
        'image': imageUrl,
        'price': priceValue,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm $productName vào giỏ hàng'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _handleBuyNow(String productName, String imageUrl, String price) {
    _checkLoginAndProceed(() {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final priceValue = double.parse(price.replaceAll('\$', ''));

      // Thêm sản phẩm vào giỏ hàng
      cartProvider.addItem({
        'name': productName,
        'image': imageUrl,
        'price': priceValue,
      });

      // Chuyển đến trang thanh toán
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> products = [
      {
        'image': 'assets/images/ao-liv-do.jpg',
        'name': 'áo Livepool đỏ',
        'price': '\$100',
      },
      {
        'image': 'assets/images/ao-liverpool-trangnau.jpg',
        'name': 'áo Livepool trắng nâu',
        'price': '\$100',
      },
      {
        'image': 'assets/images/ao-mu-do.jpg',
        'name': 'áo Manchester United',
        'price': '\$120',
      },
      {
        'image': 'assets/images/ao-mu-xanhden.jpg',
        'name': 'áo Manchester United xanh đen',
        'price': '\$120',
      },
    ];

    return Scaffold(
      appBar: TopNavbar(
        title: "Danh mục sản phẩm",
        scaffoldKey: _scaffoldKey,
        onLoginSuccess: _onLoginSuccess,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Hiển thị 2 cột
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7, // Tỉ lệ chiều rộng / chiều cao
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              imageUrl: product['image']!,
              name: product['name']!,
              price: product['price']!,
              onAddToCart:
                  () => _handleAddToCart(
                    product['name']!,
                    product['image']!,
                    product['price']!,
                  ),
              onBuy:
                  () => _handleBuyNow(
                    product['name']!,
                    product['image']!,
                    product['price']!,
                  ),
            );
          },
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: currentIndex, onTap: onTap),
    );
  }
}
