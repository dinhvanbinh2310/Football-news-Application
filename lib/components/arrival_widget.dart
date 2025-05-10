import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        "date": "10/01/2024",
        "isFavorite": true,
      },
      {
        "imageUrl": "assets/images/arrival2.jpg",
        "title": "Chuyển nhượng mùa đông",
        "description":
            "Man United đang đàm phán với Bayern Munich về thương vụ chuyển nhượng Matthijs de Ligt",
        "date": "09/01/2024",
        "isFavorite": false,
      },
      {
        "imageUrl": "assets/images/arrival3.jpg",
        "title": "Tin tức Champions League",
        "description": "Real Madrid vs RB Leipzig: Kèo thơm cho nhà cái",
        "date": "08/01/2024",
        "isFavorite": true,
      },
    ];

    return SizedBox(
      height: 230,
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
            date: arrivals[index]["date"] ?? "",
            isFavorite: arrivals[index]["isFavorite"] ?? false,
          );
        },
      ),
    );
  }
}
