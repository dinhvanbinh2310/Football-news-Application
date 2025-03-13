import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16), // Khoảng cách padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái tiêu đề
        children: <Widget>[
          // Tiêu đề "News & Community"
          Text(
            'News & Community',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Mulish',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 10), // Khoảng cách giữa tiêu đề và danh sách tin tức
          // Danh sách các bài tin tức
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Cách đều các item
            children: [
              _newsItem(
                imageUrl: 'https://via.placeholder.com/100', // Ảnh giả
                title: 'Tin tức 1',
              ),
              _newsItem(
                imageUrl: 'https://via.placeholder.com/100',
                title: 'Tin tức 2',
              ),
              _newsItem(
                imageUrl: 'https://via.placeholder.com/100',
                title: 'Tin tức 3',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget hiển thị một tin tức nhỏ (ảnh + tiêu đề)
  Widget _newsItem({required String imageUrl, required String title}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8), // Bo tròn ảnh
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
