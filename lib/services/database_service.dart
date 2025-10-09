import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_hive.dart';
import '../models/product_hive.dart';
import '../models/cart_item_hive.dart';
import '../models/theme_preference.dart';

class DatabaseService {
  static const String categoriesBox = 'categories';
  static const String productsBox = 'products';
  static const String cartBox = 'cart';
  static const String themeBox = 'theme_preferences';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CategoryHiveAdapter());
    Hive.registerAdapter(ProductHiveAdapter());
    Hive.registerAdapter(CartItemHiveAdapter());
    Hive.registerAdapter(AppThemeModeAdapter());
    Hive.registerAdapter(ThemePreferenceAdapter());

    // Open boxes
    await Hive.openBox<CategoryHive>(categoriesBox);
    await Hive.openBox<ProductHive>(productsBox);
    await Hive.openBox<CartItemHive>(cartBox);
    await Hive.openBox<ThemePreference>(themeBox);
  }

  // Category operations
  static Box<CategoryHive> getCategoriesBox() {
    return Hive.box<CategoryHive>(categoriesBox);
  }

  static Future<void> saveCategories(List<CategoryHive> categories) async {
    final box = getCategoriesBox();
    await box.clear();
    for (var category in categories) {
      await box.put(category.id, category);
    }
  }

  static List<CategoryHive> getAllCategories() {
    return getCategoriesBox().values.toList();
  }

  static CategoryHive? getCategoryById(String id) {
    return getCategoriesBox().get(id);
  }

  // Product operations
  static Box<ProductHive> getProductsBox() {
    return Hive.box<ProductHive>(productsBox);
  }

  static Future<void> saveProducts(List<ProductHive> products) async {
    final box = getProductsBox();
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product);
    }
  }

  static List<ProductHive> getAllProducts() {
    return getProductsBox().values.toList();
  }

  static ProductHive? getProductById(String id) {
    return getProductsBox().get(id);
  }

  static List<ProductHive> getProductsByCategory(String categoryId) {
    return getProductsBox()
        .values
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  // Cart operations
  static Box<CartItemHive> getCartBox() {
    return Hive.box<CartItemHive>(cartBox);
  }

  static Future<void> addToCart(CartItemHive item) async {
    final box = getCartBox();
    await box.put(item.product.id, item);
  }

  static Future<void> removeFromCart(String productId) async {
    final box = getCartBox();
    await box.delete(productId);
  }

  static Future<void> clearCart() async {
    final box = getCartBox();
    await box.clear();
  }

  static List<CartItemHive> getCartItems() {
    return getCartBox().values.toList();
  }

  static Future<void> updateCartItemQuantity(String productId, int quantity) async {
    final box = getCartBox();
    final item = box.get(productId);
    if (item != null) {
      item.quantity = quantity;
      await item.save();
    }
  }
}
