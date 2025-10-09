import 'package:hive/hive.dart';
import 'product_hive.dart';

part 'cart_item_hive.g.dart';

@HiveType(typeId: 2)
class CartItemHive extends HiveObject {
  @HiveField(0)
  ProductHive product;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String? note;

  CartItemHive({
    required this.product,
    this.quantity = 1,
    this.note,
  });

  double get totalPrice => product.price * quantity;

  CartItemHive copyWith({
    ProductHive? product,
    int? quantity,
    String? note,
  }) {
    return CartItemHive(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
