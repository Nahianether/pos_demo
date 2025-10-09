import 'cart_item.dart';

enum PaymentMethod { cash, card, digital }

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final double totalAmount;
  final double tax;
  final double discount;
  final PaymentMethod paymentMethod;
  final String? customerName;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.totalAmount,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.paymentMethod,
    this.customerName,
  });

  double get grandTotal => totalAmount + tax - discount;
}
