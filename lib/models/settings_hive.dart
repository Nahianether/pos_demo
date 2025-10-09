import 'package:hive/hive.dart';

part 'settings_hive.g.dart';

@HiveType(typeId: 5)
class SettingsHive extends HiveObject {
  @HiveField(0)
  double vatPercentage;

  @HiveField(1)
  double discountPercentage;

  @HiveField(2)
  double discountAmount;

  @HiveField(3)
  bool isDiscountPercentage; // true for %, false for fixed amount

  @HiveField(4)
  bool enableRoundOff;

  @HiveField(5)
  DateTime lastUpdated;

  SettingsHive({
    this.vatPercentage = 0.0,
    this.discountPercentage = 0.0,
    this.discountAmount = 0.0,
    this.isDiscountPercentage = true,
    this.enableRoundOff = false,
    required this.lastUpdated,
  });

  // Calculate VAT amount
  double calculateVat(double subtotal) {
    return subtotal * (vatPercentage / 100);
  }

  // Calculate discount amount
  double calculateDiscount(double subtotal) {
    if (isDiscountPercentage) {
      return subtotal * (discountPercentage / 100);
    } else {
      return discountAmount;
    }
  }

  // Calculate final total
  double calculateTotal(double subtotal) {
    final vat = calculateVat(subtotal);
    final discount = calculateDiscount(subtotal);
    final total = subtotal + vat - discount;

    if (enableRoundOff) {
      return total.roundToDouble();
    }
    return total;
  }

  // Calculate round-off adjustment
  double calculateRoundOffAdjustment(double subtotal) {
    if (!enableRoundOff) return 0.0;

    final vat = calculateVat(subtotal);
    final discount = calculateDiscount(subtotal);
    final total = subtotal + vat - discount;
    final rounded = total.roundToDouble();

    return rounded - total;
  }
}
