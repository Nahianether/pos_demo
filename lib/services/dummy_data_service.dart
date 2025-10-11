import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/category_hive.dart';
import '../models/product_hive.dart';
import 'database_service.dart';

class DummyDataService {
  static final _uuid = const Uuid();
  static final _random = Random();

  /// Generate comprehensive dummy data for the POS system
  static Future<void> generateDummyData({int categoriesCount = 50, int productsPerCategory = 10}) async {
    final categories = _generateCategories(categoriesCount);
    final products = _generateProducts(categories, productsPerCategory);

    await DatabaseService.saveCategories(categories);
    await DatabaseService.saveProducts(products);
  }

  /// Clear all data from database
  static Future<void> clearAllData() async {
    await DatabaseService.getCategoriesBox().clear();
    await DatabaseService.getProductsBox().clear();
    await DatabaseService.clearCart();
  }

  /// Generate categories with parent-child relationships
  static List<CategoryHive> _generateCategories(int count) {
    final List<CategoryHive> categories = [];
    final icons = [
      '🍔', '🍕', '🍗', '🥗', '🍰', '☕', '🍜', '🍣', '🥤', '🍺',
      '🍖', '🌮', '🍱', '🍝', '🧁', '🥪', '🍟', '🍤', '🥙', '🍛',
      '🥘', '🥟', '🍲', '🍧', '🍨', '🍩', '🧆', '🥧', '🍪', '🥐',
      '👕', '👔', '👗', '👠', '👟', '🎮', '📱', '💻', '⌚', '📷',
      '🎧', '🎸', '🎹', '🎨', '📚', '✏️', '🎁', '🧸', '⚽', '🏀',
    ];

    final colors = [
      'FF3498DB', 'FF27AE60', 'FFE67E22', 'FF9B59B6', 'FFE74C3C',
      'FF1ABC9C', 'FFF39C12', 'FF34495E', 'FF16A085', 'FF2ECC71',
      'FF3498DB', 'FFF1C40F', 'FFE67E22', 'FFE74C3C', 'FFECF0F1',
      'FF95A5A6', 'FF8E44AD', 'FF2C3E50', 'FFD35400', 'FFC0392B',
    ];

    final mainCategories = [
      'Food & Beverages', 'Electronics', 'Clothing', 'Home & Garden',
      'Sports & Outdoors', 'Books & Media', 'Toys & Games', 'Health & Beauty',
      'Automotive', 'Office Supplies', 'Pet Supplies', 'Baby Products',
      'Grocery', 'Pharmacy', 'Bakery', 'Cafe', 'Restaurant', 'Bar',
      'Hardware', 'Jewelry', 'Footwear', 'Accessories', 'Furniture', 'Appliances',
    ];

    final subCategoryPrefixes = [
      'Premium', 'Organic', 'Fresh', 'Hot', 'Cold', 'Frozen', 'Local',
      'International', 'Specialty', 'Regular', 'Deluxe', 'Budget', 'Kids',
      'Adult', 'Men\'s', 'Women\'s', 'Unisex', 'Seasonal', 'Sale', 'New',
    ];

    // Generate main categories (level 0)
    final mainCount = min(count ~/ 3, mainCategories.length);
    for (int i = 0; i < mainCount; i++) {
      categories.add(CategoryHive(
        id: _uuid.v4(),
        name: mainCategories[i % mainCategories.length],
        parentId: null,
        icon: icons[i % icons.length],
        color: colors[i % colors.length],
        level: 0,
      ));
    }

    // Generate subcategories (level 1 & 2)
    int currentCount = categories.length;
    while (currentCount < count) {
      final parentCategory = categories[_random.nextInt(categories.length)];

      // Only create subcategories up to level 2
      if (parentCategory.level < 2) {
        final prefix = subCategoryPrefixes[_random.nextInt(subCategoryPrefixes.length)];
        final name = '$prefix ${parentCategory.name}';

        categories.add(CategoryHive(
          id: _uuid.v4(),
          name: name,
          parentId: parentCategory.id,
          icon: icons[_random.nextInt(icons.length)],
          color: colors[_random.nextInt(colors.length)],
          level: parentCategory.level + 1,
        ));
        currentCount++;
      }
    }

    return categories;
  }

  /// Generate products for categories
  static List<ProductHive> _generateProducts(List<CategoryHive> categories, int productsPerCategory) {
    final List<ProductHive> products = [];

    final productNames = [
      // Food items
      'Classic Burger', 'Cheese Pizza', 'Chicken Wings', 'Caesar Salad', 'Chocolate Cake',
      'Espresso', 'Cappuccino', 'Latte', 'Mocha', 'Green Tea',
      'Ramen Bowl', 'Sushi Roll', 'Pad Thai', 'Fried Rice', 'Tom Yum Soup',
      'Fish and Chips', 'Steak', 'Lamb Chops', 'Grilled Salmon', 'BBQ Ribs',
      'Margherita Pizza', 'Pepperoni Pizza', 'Vegetarian Pizza', 'Meat Lovers Pizza',
      'Chicken Tacos', 'Beef Burrito', 'Quesadilla', 'Nachos', 'Enchiladas',
      'Pasta Carbonara', 'Spaghetti Bolognese', 'Lasagna', 'Fettuccine Alfredo',
      'Croissant', 'Muffin', 'Bagel', 'Danish Pastry', 'Cinnamon Roll',
      'Ice Cream Sundae', 'Milkshake', 'Smoothie', 'Fresh Juice', 'Soda',

      // Electronics
      'Wireless Mouse', 'Keyboard', 'USB Cable', 'HDMI Cable', 'Power Bank',
      'Smartphone', 'Tablet', 'Laptop', 'Desktop Computer', 'Monitor',
      'Headphones', 'Earbuds', 'Speakers', 'Microphone', 'Webcam',
      'Smart Watch', 'Fitness Tracker', 'Gaming Console', 'Controller',
      'Memory Card', 'Flash Drive', 'External HDD', 'SSD', 'Router',

      // Clothing
      'T-Shirt', 'Polo Shirt', 'Dress Shirt', 'Jeans', 'Chinos',
      'Hoodie', 'Jacket', 'Coat', 'Sweater', 'Cardigan',
      'Dress', 'Skirt', 'Blouse', 'Leggings', 'Shorts',
      'Sneakers', 'Boots', 'Sandals', 'Loafers', 'Heels',
      'Belt', 'Hat', 'Cap', 'Scarf', 'Gloves', 'Socks',

      // General items
      'Notebook', 'Pen', 'Pencil', 'Marker', 'Highlighter',
      'Backpack', 'Handbag', 'Wallet', 'Sunglasses', 'Watch',
      'Water Bottle', 'Coffee Mug', 'Thermos', 'Lunch Box',
      'Towel', 'Pillow', 'Blanket', 'Mattress', 'Lamp',
      'Plant Pot', 'Vase', 'Frame', 'Mirror', 'Clock',
      'Toy Car', 'Puzzle', 'Board Game', 'Action Figure', 'Doll',
      'Novel', 'Magazine', 'Comic Book', 'Journal', 'Calendar',
      'Shampoo', 'Conditioner', 'Soap', 'Toothpaste', 'Toothbrush',
      'Perfume', 'Deodorant', 'Lotion', 'Cream', 'Face Mask',
    ];

    final adjectives = [
      'Premium', 'Deluxe', 'Classic', 'Special', 'Signature',
      'Fresh', 'Homemade', 'Organic', 'Natural', 'Artisan',
      'Spicy', 'Sweet', 'Savory', 'Crispy', 'Juicy',
      'Large', 'Medium', 'Small', 'Jumbo', 'Mini',
      'Hot', 'Cold', 'Frozen', 'Chilled', 'Warm',
    ];

    final units = ['pcs', 'kg', 'g', 'L', 'ml', 'oz', 'lb', 'pack', 'box', 'can'];

    final descriptions = [
      'High quality product',
      'Customer favorite',
      'Best seller',
      'Limited edition',
      'Seasonal special',
      'Recommended by chef',
      'House specialty',
      'Perfect for sharing',
      'Great value',
      'Premium quality',
    ];

    for (var category in categories) {
      // Generate more products for leaf categories
      final count = category.level == 2 ? productsPerCategory : max(1, productsPerCategory ~/ 2);

      for (int i = 0; i < count; i++) {
        final baseName = productNames[_random.nextInt(productNames.length)];
        final adjective = _random.nextBool() ? '${adjectives[_random.nextInt(adjectives.length)]} ' : '';
        final name = '$adjective$baseName';

        // Price range based on category level
        final basePrice = 5.0 + (_random.nextDouble() * 95.0); // $5 - $100
        final price = (basePrice * 100).round() / 100; // Round to 2 decimal places

        products.add(ProductHive(
          id: _uuid.v4(),
          name: name,
          categoryId: category.id,
          price: price,
          description: descriptions[_random.nextInt(descriptions.length)],
          isAvailable: _random.nextDouble() > 0.1, // 90% available
          unit: units[_random.nextInt(units.length)],
          lastUpdated: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        ));
      }
    }

    return products;
  }

  /// Generate quick sample data (fewer items for quick testing)
  static Future<void> generateQuickSampleData() async {
    await generateDummyData(categoriesCount: 10, productsPerCategory: 5);
  }

  /// Generate large dataset for stress testing
  static Future<void> generateLargeDataset() async {
    await generateDummyData(categoriesCount: 100, productsPerCategory: 20);
  }

  /// Get statistics about current data
  static Map<String, int> getDataStatistics() {
    final categories = DatabaseService.getAllCategories();
    final products = DatabaseService.getAllProducts();

    final level0Categories = categories.where((c) => c.level == 0).length;
    final level1Categories = categories.where((c) => c.level == 1).length;
    final level2Categories = categories.where((c) => c.level == 2).length;

    return {
      'totalCategories': categories.length,
      'level0Categories': level0Categories,
      'level1Categories': level1Categories,
      'level2Categories': level2Categories,
      'totalProducts': products.length,
      'availableProducts': products.where((p) => p.isAvailable).length,
      'unavailableProducts': products.where((p) => !p.isAvailable).length,
    };
  }
}
