import 'package:hive/hive.dart';

part 'product_hive.g.dart';

@HiveType(typeId: 1)
class ProductHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  double price;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  String? description;

  @HiveField(6)
  bool isAvailable;

  @HiveField(7)
  String? unit;

  @HiveField(8)
  DateTime lastUpdated;

  ProductHive({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imageUrl,
    this.description,
    this.isAvailable = true,
    this.unit,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  ProductHive copyWith({
    String? id,
    String? name,
    String? categoryId,
    double? price,
    String? imageUrl,
    String? description,
    bool? isAvailable,
    String? unit,
    DateTime? lastUpdated,
  }) {
    return ProductHive(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
