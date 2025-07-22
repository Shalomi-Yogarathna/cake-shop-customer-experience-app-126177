class Order {
  final String id;
  final String status;
  final DateTime createdAt;
  final double totalPrice;
  final String deliveryTime;
  final String deliveryAddress;
  // Add further order details as needed

  Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.totalPrice,
    required this.deliveryTime,
    required this.deliveryAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
      deliveryTime: json['delivery_time'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
    );
  }
}
