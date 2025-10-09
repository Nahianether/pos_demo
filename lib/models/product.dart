class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String? imageUrl;
  final String? description;
  final bool isAvailable;
  final String? unit;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imageUrl,
    this.description,
    this.isAvailable = true,
    this.unit,
  });

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    double? price,
    String? imageUrl,
    String? description,
    bool? isAvailable,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      unit: unit ?? this.unit,
    );
  }
}
