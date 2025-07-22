class Cake {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final List<String> flavors;
  final List<String> sizes;
  final List<String> toppings;
  final double rating;
  final int reviewCount;

  Cake({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categories,
    required this.flavors,
    required this.sizes,
    required this.toppings,
    required this.rating,
    required this.reviewCount,
  });

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      flavors: List<String>.from(json['flavors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      toppings: List<String>.from(json['toppings'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
    );
  }
}
