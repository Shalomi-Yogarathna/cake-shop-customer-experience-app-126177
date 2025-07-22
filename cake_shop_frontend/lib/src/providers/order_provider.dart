import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // PUBLIC_INTERFACE
  Future<void> fetchOrders(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      _orders = await ApiService.getOrders(token: token);
    } catch (_) {
      _orders = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> placeOrder(BuildContext context, Map<String, dynamic> payload) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    final order = await ApiService.placeOrder(payload, token: token);
    _orders.insert(0, order);
    notifyListeners();
  }
}
