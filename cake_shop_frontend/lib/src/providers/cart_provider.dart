import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/cake.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  // PUBLIC_INTERFACE
  void addToCart(Cake cake, String size, String flavor, List<String> toppings, String customMessage, int qty) {
    _items.add(CartItem(
      cake: cake,
      size: size,
      flavor: flavor,
      toppings: toppings,
      customMessage: customMessage,
      quantity: qty,
    ));
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  void removeFromCart(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // PUBLIC_INTERFACE
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
