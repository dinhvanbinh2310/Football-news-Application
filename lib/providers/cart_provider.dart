import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  double _totalPrice = 0;

  List<Map<String, dynamic>> get items => _items;
  double get totalPrice => _totalPrice;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      _items = List<Map<String, dynamic>>.from(
        json.decode(cartData).map((x) => Map<String, dynamic>.from(x)),
      );
      _updateTotalPrice();
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', json.encode(_items));
  }

  void _updateTotalPrice() {
    _totalPrice = _items.fold(
      0,
      (sum, item) => sum + (item['price'] as double),
    );
  }

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    _updateTotalPrice();
    _saveCart();
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _updateTotalPrice();
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _updateTotalPrice();
    _saveCart();
    notifyListeners();
  }
}
