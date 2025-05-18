import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/new_service.dart';
import 'package:flutter_application_1/models/new_model.dart';
import 'card_arrival.dart';

class NewArrivals extends StatelessWidget {
  final NewsService newsService = NewsService();

  NewArrivals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: newsService.fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 230,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 230,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 230,
            child: Center(child: Text('No news available')),
          );
        } else {
          // Lấy 3 bài mới nhất theo createdAt giảm dần
          List<News> sortedNews = List.from(snapshot.data!);
          sortedNews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final latestThree = sortedNews.take(3).toList();

          return SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: latestThree.length,
              padding: const EdgeInsets.only(left: 16),
              itemBuilder: (context, index) {
                final news = latestThree[index];
                return CardArrival(
                  imageUrl: news.imageUrl ?? "",
                  title: news.title,
                  description: news.description ?? "No description available",
                  date: "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                  isFavorite: false, // Bạn có thể thêm logic yêu thích nếu cần
                );
              },
            ),
          );
        }
      },
    );
  }
}
