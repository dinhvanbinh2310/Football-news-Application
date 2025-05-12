class Merchandise {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> size;
  final List<String> color;
  final String category;
  final int stock;
  final List<String> image;
  final bool isAvailable;

  Merchandise({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.size,
    required this.color,
    required this.category,
    required this.stock,
    required this.image,
    required this.isAvailable,
  });

  factory Merchandise.fromJson(Map<String, dynamic> json) {
    return Merchandise(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      size: List<String>.from(json['size']),
      color: List<String>.from(json['color']),
      category: json['category'],
      stock: json['stock'],
      image: List<String>.from(json['image']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
