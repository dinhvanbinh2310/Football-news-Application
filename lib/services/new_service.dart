import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/new_model.dart';

class NewsService {
  final String apiUrl = "http://10.0.2.2:3000/news";

  // Lấy tất cả các bài viết
  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => News.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }

  // Thêm bài viết mới
  Future<News> createNews(News news) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(news.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return News.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create news");
    }
  }

  // Cập nhật bài viết
  Future<News> updateNews(String id, News news) async {
    final response = await http.put(
      Uri.parse("$apiUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(news.toJson()),
    );

    if (response.statusCode == 200) {
      return News.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update news");
    }
  }

  // Xóa bài viết
  Future<void> deleteNews(String id) async {
    final response = await http.delete(Uri.parse("$apiUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete news");
    }
  }
}
