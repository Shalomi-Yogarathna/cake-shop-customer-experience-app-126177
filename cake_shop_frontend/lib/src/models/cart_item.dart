import 'cake.dart';

class CartItem {
  final Cake cake;
  final String size;
  final String flavor;
  final List<String> toppings;
  final String customMessage;
  final int quantity;

  CartItem({
    required this.cake,
    required this.size,
    required this.flavor,
    required this.toppings,
    required this.customMessage,
    required this.quantity,
  });

  double get totalPrice =>
      cake.price * quantity; // (could add flavor/topping price adjustments)
}
