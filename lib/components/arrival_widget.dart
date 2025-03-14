import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewArrivalsWidget extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: "Product 1",
      price: "\$15.18",
      imagePath: "assets/images/product1.svg",
    ),
    Product(
      name: "Product 2",
      price: "\$18.99",
      imagePath: "assets/images/product2.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'New Arrivals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                products
                    .map((product) => ProductCard(product: product))
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(product.imagePath, height: 100),
          ),
          Text(
            product.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            product.price,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String price;
  final String imagePath;

  Product({required this.name, required this.price, required this.imagePath});
}
