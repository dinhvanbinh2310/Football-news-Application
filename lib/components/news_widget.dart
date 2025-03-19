import 'dart:async';
import 'package:flutter/material.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  final List<Map<String, String>> newsList = [
    {'imageUrl': 'assets/images/news3.jpg', 'title': 'Tin tức 1'},
    {'imageUrl': 'assets/images/news2.jpg', 'title': 'Tin tức 2'},
    {'imageUrl': 'assets/images/news1.jpg', 'title': 'Tin tức 3'},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentIndex < newsList.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // Quay lại ảnh đầu tiên khi hết danh sách
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Thêm SingleChildScrollView ở đây
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          SizedBox(height: 10),
          // Slider hình ảnh
          SizedBox(
            height: 350, // Chiều cao slider
            child: PageView.builder(
              controller: _pageController,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return _newsItem(
                  imageUrl: newsList[index]['imageUrl']!,
                  title: newsList[index]['title']!,
                );
              },
            ),
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
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageUrl,
            width: double.infinity,
            height: 300,
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
