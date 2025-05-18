import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/new_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Hiển thị ảnh bìa nếu có
            news.imageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news.imageUrl!,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              color: Colors.grey[200],
              height: 200,
            ),
            SizedBox(height: 20),
            // Tiêu đề
            Text(
              news.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Nội dung chi tiết
            Text(
              news.content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            // Thông tin bổ sung khác (ví dụ: ngày tạo, tóm tắt...)
            if (news.description != null)
              Text(
                'Description: ${news.description}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            SizedBox(height: 10),
            Text(
              'Created At: ${news.createdAt}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
