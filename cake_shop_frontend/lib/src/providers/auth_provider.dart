import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

/// App authentication and token (memory + persistent storage)
class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;

  String? get token => _token;

  bool get isAuthenticated => _isAuthenticated;

  // PUBLIC_INTERFACE
  Future<void> login(String username, String password) async {
    _token = await ApiService.login(username, password);
    _isAuthenticated = true;
    await _persistToken();
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> signup(String username, String email, String password) async {
    _token = await ApiService.signup(username, email, password);
    _isAuthenticated = true;
    await _persistToken();
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    _isAuthenticated = _token != null && _token!.isNotEmpty;
    notifyListeners();
  }

  Future<void> _persistToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('authToken', _token!);
    }
  }
}
