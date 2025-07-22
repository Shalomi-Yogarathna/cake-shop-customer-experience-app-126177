import 'package:flutter/material.dart';
import '../models/cake.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class CakeProvider with ChangeNotifier {
  List<Cake> _cakes = [];
  bool _isLoading = false;
  String? _filterCategory;
  String? _filterFlavor;

  List<Cake> get cakes => _cakes;
  bool get isLoading => _isLoading;
  String? get filterCategory => _filterCategory;
  String? get filterFlavor => _filterFlavor;

  // PUBLIC_INTERFACE
  Future<void> fetchCakes(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      _cakes = await ApiService.getCakes(token: token, filters: {
        if (_filterCategory != null && _filterCategory!.isNotEmpty) 'category': _filterCategory!,
        if (_filterFlavor != null && _filterFlavor!.isNotEmpty) 'flavor': _filterFlavor!,
      });
    } catch (_) {
      _cakes = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  void setCategory(String? cat) {
    _filterCategory = cat;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  void setFlavor(String? flavor) {
    _filterFlavor = flavor;
    notifyListeners();
  }
}
