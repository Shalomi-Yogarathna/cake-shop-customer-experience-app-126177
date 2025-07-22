import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cake.dart';
import '../models/order.dart';
import '../models/user.dart';

class ApiService {
  static final String _apiUrl = dotenv.env['API_URL'] ?? "http://localhost:8000";

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token'
    };
  }

  // PUBLIC_INTERFACE
  static Future<List<Cake>> getCakes({String? token, Map<String, String>? filters}) async {
    String url = '$_apiUrl/cakes';
    if (filters != null && filters.isNotEmpty) {
      final qs = Uri(queryParameters: filters).query;
      url += '?$qs';
    }
    final resp = await http.get(Uri.parse(url), headers: _headers(token));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.map((e) => Cake.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch cakes');
  }

  // PUBLIC_INTERFACE
  static Future<Cake> getCakeDetail(int cakeId, {String? token}) async {
    final url = '$_apiUrl/cakes/$cakeId';
    final resp = await http.get(Uri.parse(url), headers: _headers(token));
    if (resp.statusCode == 200) {
      return Cake.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Failed to fetch cake');
  }

  // PUBLIC_INTERFACE
  static Future<List<Order>> getOrders({String? token}) async {
    final url = '$_apiUrl/orders';
    final resp = await http.get(Uri.parse(url), headers: _headers(token));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.map((e) => Order.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch orders');
  }

  // PUBLIC_INTERFACE
  static Future<Order> placeOrder(Map<String, dynamic> payload, {String? token}) async {
    final url = '$_apiUrl/orders';
    final resp = await http.post(Uri.parse(url),
        headers: _headers(token), body: jsonEncode(payload));
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return Order.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Order placement failed');
  }

  // PUBLIC_INTERFACE
  static Future<String> login(String username, String password) async {
    final url = '$_apiUrl/auth/login';
    final resp = await http.post(Uri.parse(url),
      headers: _headers(null),
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (resp.statusCode == 200) {
      var result = jsonDecode(resp.body);
      return result['access_token'];
    }
    throw Exception('Login failed');
  }

  // PUBLIC_INTERFACE
  static Future<String> signup(String username, String email, String password) async {
    final url = '$_apiUrl/auth/signup';
    final resp = await http.post(Uri.parse(url),
      headers: _headers(null),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    if (resp.statusCode == 201) {
      var result = jsonDecode(resp.body);
      return result['access_token'];
    }
    throw Exception('Signup failed');
  }

  // PUBLIC_INTERFACE
  static Future<User> getProfile({required String token}) async {
    final url = '$_apiUrl/users/profile';
    final resp = await http.get(Uri.parse(url), headers: _headers(token));
    if (resp.statusCode == 200) {
      return User.fromJson(jsonDecode(resp.body));
    }
    throw Exception('Get profile failed');
  }

  // PUBLIC_INTERFACE
  static Future<void> updateProfile({required String token, required Map<String, dynamic> updates}) async {
    final url = '$_apiUrl/users/profile';
    final resp = await http.put(Uri.parse(url),
      headers: _headers(token),
      body: jsonEncode(updates),
    );
    if (resp.statusCode != 200) throw Exception('Update profile failed');
  }

  // PUBLIC_INTERFACE
  static Future<Map<String, dynamic>> getAdminAnalytics({required String token}) async {
    final url = '$_apiUrl/admin/analytics';
    final resp = await http.get(Uri.parse(url), headers: _headers(token));
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to fetch analytics');
  }

  // Add other endpoints as needed for cart, toppings, etc.
}
