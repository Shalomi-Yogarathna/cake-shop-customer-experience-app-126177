import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // PUBLIC_INTERFACE
  Future<void> fetchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;
    try {
      _user = await ApiService.getProfile(token: token);
    } catch (_) {
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> updateProfile(BuildContext context, Map<String, dynamic> updates) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;
    await ApiService.updateProfile(token: token, updates: updates);
    await fetchProfile(context);
  }
}
