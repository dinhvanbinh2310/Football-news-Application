import 'package:flutter/material.dart';
import 'card_arrival.dart';

class NewArrivals extends StatelessWidget {
  const NewArrivals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> arrivals = [
      {
        "imageUrl": "assets/images/arrival1.jpg",
        "title": "Tin Bóng Đá Mới Nhất",
        "description":
            "10/01 ĐTVN thua đội cửa dưới, HLV Troussier tiếp tục thử nghiệm thay vì đá thật",
        "isFavorite": true,
      },
      {
        "imageUrl": "assets/images/arrival2.jpg",
        "title": "Another Product",
        "description": "20.00",
        "isFavorite": false,
      },
      // Thêm sản phẩm khác nếu cần
    ];

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: arrivals.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          return CardArrival(
            imageUrl: arrivals[index]["imageUrl"] ?? "",
            title: arrivals[index]["title"] ?? "No title",
            description:
                arrivals[index]["description"] ?? "No description available",
            isFavorite: arrivals[index]["isFavorite"] ?? false,
          );
        },
      ),
    );
  }
}
