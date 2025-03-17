import 'package:flutter/material.dart';

class CardArrival extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isFavorite;

  const CardArrival({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Độ rộng của card
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isFavorite)
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: Icon(Icons.favorite, color: Colors.red, size: 18),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  maxLines: 2, // Hiển thị tối đa 2 dòng
                  overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
