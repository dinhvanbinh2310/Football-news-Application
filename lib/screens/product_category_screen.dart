import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/product_card.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/components/top_navbar.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({Key? key}) : super(key: key);
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  int currentIndex = 0; // Khai báo currentIndex
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;

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
    setState(() {
      isLoggedIn = true;
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
            return ProductCard(
              imageUrl: products[index]['image']!,
              name: products[index]['name']!,
              price: products[index]['price']!,
            );
          },
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: currentIndex, onTap: onTap),
    );
  }
}
