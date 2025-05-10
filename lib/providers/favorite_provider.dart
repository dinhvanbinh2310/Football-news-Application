import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  // Lưu id hoặc unique key của sản phẩm/tin tức
  final List<String> _favoriteProducts = [];
  final List<String> _favoriteNews = [];

  List<String> get favoriteProducts => _favoriteProducts;
  List<String> get favoriteNews => _favoriteNews;

  bool isProductFavorite(String id) => _favoriteProducts.contains(id);
  bool isNewsFavorite(String id) => _favoriteNews.contains(id);

  void toggleProductFavorite(String id) {
    if (_favoriteProducts.contains(id)) {
      _favoriteProducts.remove(id);
    } else {
      _favoriteProducts.add(id);
    }
    notifyListeners();
  }

  void toggleNewsFavorite(String id) {
    if (_favoriteNews.contains(id)) {
      _favoriteNews.remove(id);
    } else {
      _favoriteNews.add(id);
    }
    notifyListeners();
  }
}
