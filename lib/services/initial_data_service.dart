import '../models/category_hive.dart';
import '../models/product_hive.dart';
import 'database_service.dart';

class InitialDataService {
  /// Initialize app with realistic hardcoded data
  /// Set forceReload to true to clear existing data and reload
  static Future<void> initializeData({bool forceReload = false}) async {
    final categoriesBox = DatabaseService.getCategoriesBox();
    final productsBox = DatabaseService.getProductsBox();

    // Clear and reload if forceReload is true
    if (forceReload) {
      await clearAllData();
    }

    // Load data if boxes are empty
    if (categoriesBox.isEmpty || productsBox.isEmpty) {
      final categories = _getInitialCategories();
      final products = _getInitialProducts();

      await DatabaseService.saveCategories(categories);
      await DatabaseService.saveProducts(products);
    }
  }

  static List<CategoryHive> _getInitialCategories() {
    return [
      // Main Categories (Level 0)
      CategoryHive(
        id: 'cat_food',
        name: 'Food & Beverages',
        parentId: null,
        icon: '🍔',
        color: 'FFFF6B6B',
        level: 0,
      ),
      CategoryHive(
        id: 'cat_electronics',
        name: 'Electronics',
        parentId: null,
        icon: '📱',
        color: 'FF4ECDC4',
        level: 0,
      ),
      CategoryHive(
        id: 'cat_fashion',
        name: 'Fashion',
        parentId: null,
        icon: '👕',
        color: 'FF95E1D3',
        level: 0,
      ),
      CategoryHive(
        id: 'cat_home',
        name: 'Home & Living',
        parentId: null,
        icon: '🏠',
        color: 'FFF38181',
        level: 0,
      ),

      // Food & Beverages Subcategories (Level 1)
      CategoryHive(
        id: 'cat_fast_food',
        name: 'Fast Food',
        parentId: 'cat_food',
        icon: '🍕',
        color: 'FFFF6B6B',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_beverages',
        name: 'Beverages',
        parentId: 'cat_food',
        icon: '☕',
        color: 'FFAA6B39',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_desserts',
        name: 'Desserts',
        parentId: 'cat_food',
        icon: '🍰',
        color: 'FFFF85AB',
        level: 1,
      ),

      // Fast Food Subcategories (Level 2)
      CategoryHive(
        id: 'cat_burgers',
        name: 'Burgers',
        parentId: 'cat_fast_food',
        icon: '🍔',
        color: 'FFFF6B6B',
        level: 2,
      ),
      CategoryHive(
        id: 'cat_pizza',
        name: 'Pizza',
        parentId: 'cat_fast_food',
        icon: '🍕',
        color: 'FFFF8C42',
        level: 2,
      ),
      CategoryHive(
        id: 'cat_sides',
        name: 'Sides & Snacks',
        parentId: 'cat_fast_food',
        icon: '🍟',
        color: 'FFFFD93D',
        level: 2,
      ),
      CategoryHive(
        id: 'cat_chicken',
        name: 'Chicken',
        parentId: 'cat_fast_food',
        icon: '🍗',
        color: 'FFFF9A76',
        level: 2,
      ),

      // Beverages Subcategories (Level 2)
      CategoryHive(
        id: 'cat_coffee',
        name: 'Coffee',
        parentId: 'cat_beverages',
        icon: '☕',
        color: 'FFAA6B39',
        level: 2,
      ),
      CategoryHive(
        id: 'cat_juice',
        name: 'Juices & Smoothies',
        parentId: 'cat_beverages',
        icon: '🥤',
        color: 'FFFFA500',
        level: 2,
      ),
      CategoryHive(
        id: 'cat_soft_drinks',
        name: 'Soft Drinks',
        parentId: 'cat_beverages',
        icon: '🥤',
        color: 'FF6BCF7F',
        level: 2,
      ),

      // Electronics Subcategories (Level 1)
      CategoryHive(
        id: 'cat_mobile',
        name: 'Mobile & Tablets',
        parentId: 'cat_electronics',
        icon: '📱',
        color: 'FF4ECDC4',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_computers',
        name: 'Computers',
        parentId: 'cat_electronics',
        icon: '💻',
        color: 'FF44A08D',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_audio',
        name: 'Audio',
        parentId: 'cat_electronics',
        icon: '🎧',
        color: 'FF093637',
        level: 1,
      ),

      // Fashion Subcategories (Level 1)
      CategoryHive(
        id: 'cat_mens',
        name: "Men's Clothing",
        parentId: 'cat_fashion',
        icon: '👔',
        color: 'FF95E1D3',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_womens',
        name: "Women's Clothing",
        parentId: 'cat_fashion',
        icon: '👗',
        color: 'FFEEA990',
        level: 1,
      ),
      CategoryHive(
        id: 'cat_footwear',
        name: 'Footwear',
        parentId: 'cat_fashion',
        icon: '👟',
        color: 'FFB4A7D6',
        level: 1,
      ),
    ];
  }

  static List<ProductHive> _getInitialProducts() {
    return [
      // Burgers
      ProductHive(
        id: 'prod_burger_classic',
        name: 'Classic Beef Burger',
        categoryId: 'cat_burgers',
        price: 8.99,
        description: 'Juicy beef patty with lettuce, tomato, and special sauce',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_burger_cheese',
        name: 'Cheeseburger Deluxe',
        categoryId: 'cat_burgers',
        price: 10.99,
        description: 'Double cheese, beef patty, pickles, and mustard',
        imageUrl: 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_burger_veggie',
        name: 'Veggie Burger',
        categoryId: 'cat_burgers',
        price: 7.99,
        description: 'Plant-based patty with avocado and lettuce',
        imageUrl: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_burger_bacon',
        name: 'Bacon Cheeseburger',
        categoryId: 'cat_burgers',
        price: 12.99,
        description: 'Beef patty with crispy bacon and cheddar cheese',
        imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Pizza
      ProductHive(
        id: 'prod_pizza_margherita',
        name: 'Margherita Pizza',
        categoryId: 'cat_pizza',
        price: 12.99,
        description: 'Classic pizza with tomato sauce, mozzarella, and basil',
        imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_pizza_pepperoni',
        name: 'Pepperoni Pizza',
        categoryId: 'cat_pizza',
        price: 14.99,
        description: 'Loaded with pepperoni and extra cheese',
        imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_pizza_veggie',
        name: 'Vegetarian Pizza',
        categoryId: 'cat_pizza',
        price: 13.99,
        description: 'Bell peppers, olives, mushrooms, and onions',
        imageUrl: 'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_pizza_meat',
        name: 'Meat Lovers Pizza',
        categoryId: 'cat_pizza',
        price: 16.99,
        description: 'Pepperoni, sausage, bacon, and ham',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Sides & Snacks
      ProductHive(
        id: 'prod_fries',
        name: 'French Fries',
        categoryId: 'cat_sides',
        price: 3.99,
        description: 'Crispy golden fries with sea salt',
        imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_onion_rings',
        name: 'Onion Rings',
        categoryId: 'cat_sides',
        price: 4.99,
        description: 'Crispy breaded onion rings',
        imageUrl: 'https://images.unsplash.com/photo-1639024471283-03518883512d?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_nachos',
        name: 'Loaded Nachos',
        categoryId: 'cat_sides',
        price: 7.99,
        description: 'Tortilla chips with cheese, jalapeños, and salsa',
        imageUrl: 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Chicken
      ProductHive(
        id: 'prod_chicken_wings',
        name: 'Buffalo Chicken Wings',
        categoryId: 'cat_chicken',
        price: 11.99,
        description: '8 pieces of spicy buffalo wings with ranch dip',
        imageUrl: 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_chicken_tenders',
        name: 'Chicken Tenders',
        categoryId: 'cat_chicken',
        price: 9.99,
        description: '5 crispy chicken tenders with dipping sauce',
        imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_chicken_nuggets',
        name: 'Chicken Nuggets',
        categoryId: 'cat_chicken',
        price: 6.99,
        description: '10 golden crispy chicken nuggets',
        imageUrl: 'https://images.unsplash.com/photo-1619894991376-c686fdeeb758?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Coffee
      ProductHive(
        id: 'prod_coffee_espresso',
        name: 'Espresso',
        categoryId: 'cat_coffee',
        price: 3.50,
        description: 'Strong Italian espresso shot',
        imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
        isAvailable: true,
        unit: 'cup',
      ),
      ProductHive(
        id: 'prod_coffee_latte',
        name: 'Caffe Latte',
        categoryId: 'cat_coffee',
        price: 4.99,
        description: 'Smooth espresso with steamed milk',
        imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
        isAvailable: true,
        unit: 'cup',
      ),
      ProductHive(
        id: 'prod_coffee_cappuccino',
        name: 'Cappuccino',
        categoryId: 'cat_coffee',
        price: 4.50,
        description: 'Espresso with foamed milk and cocoa powder',
        imageUrl: 'https://images.unsplash.com/photo-1572286258217-a1f0e7020d8e?w=400',
        isAvailable: true,
        unit: 'cup',
      ),
      ProductHive(
        id: 'prod_coffee_americano',
        name: 'Americano',
        categoryId: 'cat_coffee',
        price: 3.99,
        description: 'Espresso with hot water',
        imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
        isAvailable: true,
        unit: 'cup',
      ),

      // Juices & Smoothies
      ProductHive(
        id: 'prod_juice_orange',
        name: 'Fresh Orange Juice',
        categoryId: 'cat_juice',
        price: 5.99,
        description: 'Freshly squeezed orange juice',
        imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        isAvailable: true,
        unit: 'glass',
      ),
      ProductHive(
        id: 'prod_smoothie',
        name: 'Berry Smoothie',
        categoryId: 'cat_juice',
        price: 6.99,
        description: 'Mixed berries, banana, and yogurt',
        imageUrl: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400',
        isAvailable: true,
        unit: 'glass',
      ),
      ProductHive(
        id: 'prod_juice_mango',
        name: 'Mango Lassi',
        categoryId: 'cat_juice',
        price: 5.49,
        description: 'Sweet mango yogurt drink',
        imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767?w=400',
        isAvailable: true,
        unit: 'glass',
      ),

      // Soft Drinks
      ProductHive(
        id: 'prod_soda',
        name: 'Soft Drink',
        categoryId: 'cat_soft_drinks',
        price: 2.50,
        description: 'Chilled carbonated drink',
        imageUrl: 'https://images.unsplash.com/photo-1629203851122-3726ecdf080e?w=400',
        isAvailable: true,
        unit: 'can',
      ),
      ProductHive(
        id: 'prod_iced_tea',
        name: 'Iced Tea',
        categoryId: 'cat_soft_drinks',
        price: 2.99,
        description: 'Refreshing lemon iced tea',
        imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
        isAvailable: true,
        unit: 'glass',
      ),
      ProductHive(
        id: 'prod_lemonade',
        name: 'Fresh Lemonade',
        categoryId: 'cat_soft_drinks',
        price: 3.49,
        description: 'Homemade lemonade with mint',
        imageUrl: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f9d?w=400',
        isAvailable: true,
        unit: 'glass',
      ),

      // Desserts
      ProductHive(
        id: 'prod_cake_chocolate',
        name: 'Chocolate Cake Slice',
        categoryId: 'cat_desserts',
        price: 6.50,
        description: 'Rich chocolate cake with chocolate frosting',
        imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
        isAvailable: true,
        unit: 'slice',
      ),
      ProductHive(
        id: 'prod_cake_cheesecake',
        name: 'New York Cheesecake',
        categoryId: 'cat_desserts',
        price: 7.99,
        description: 'Classic creamy cheesecake with graham crust',
        imageUrl: 'https://images.unsplash.com/photo-1533134486753-c833f0ed4866?w=400',
        isAvailable: true,
        unit: 'slice',
      ),
      ProductHive(
        id: 'prod_ice_cream',
        name: 'Ice Cream Sundae',
        categoryId: 'cat_desserts',
        price: 5.99,
        description: 'Three scoops with chocolate sauce and whipped cream',
        imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400',
        isAvailable: true,
        unit: 'cup',
      ),
      ProductHive(
        id: 'prod_brownie',
        name: 'Chocolate Brownie',
        categoryId: 'cat_desserts',
        price: 4.99,
        description: 'Warm fudgy brownie with vanilla ice cream',
        imageUrl: 'https://images.unsplash.com/photo-1564355808853-17f2e8a2c0bb?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Mobile & Tablets
      ProductHive(
        id: 'prod_iphone_15',
        name: 'iPhone 15 Pro',
        categoryId: 'cat_mobile',
        price: 999.00,
        description: 'Latest Apple iPhone with A17 Pro chip, 256GB',
        imageUrl: 'https://images.unsplash.com/photo-1695048064677-ba4afa423e5d?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_samsung_s24',
        name: 'Samsung Galaxy S24',
        categoryId: 'cat_mobile',
        price: 899.00,
        description: 'Flagship Samsung phone with 256GB storage',
        imageUrl: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_ipad',
        name: 'iPad Air',
        categoryId: 'cat_mobile',
        price: 599.00,
        description: 'Apple iPad Air with M1 chip, 64GB',
        imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_pixel',
        name: 'Google Pixel 8',
        categoryId: 'cat_mobile',
        price: 699.00,
        description: 'Google Pixel with advanced AI features',
        imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Computers
      ProductHive(
        id: 'prod_macbook',
        name: 'MacBook Pro 14"',
        categoryId: 'cat_computers',
        price: 1999.00,
        description: 'Apple MacBook Pro with M3 chip, 512GB SSD',
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_laptop_dell',
        name: 'Dell XPS 15',
        categoryId: 'cat_computers',
        price: 1599.00,
        description: 'Premium Dell laptop, Intel i7, 16GB RAM',
        imageUrl: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_mouse_wireless',
        name: 'Wireless Mouse',
        categoryId: 'cat_computers',
        price: 29.99,
        description: 'Ergonomic wireless mouse with precision tracking',
        imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_keyboard',
        name: 'Mechanical Keyboard',
        categoryId: 'cat_computers',
        price: 89.99,
        description: 'RGB mechanical keyboard with blue switches',
        imageUrl: 'https://images.unsplash.com/photo-1595225476474-87563907a212?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Audio
      ProductHive(
        id: 'prod_airpods',
        name: 'AirPods Pro',
        categoryId: 'cat_audio',
        price: 249.00,
        description: 'Apple AirPods Pro with active noise cancellation',
        imageUrl: 'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_headphones_sony',
        name: 'Sony WH-1000XM5',
        categoryId: 'cat_audio',
        price: 399.00,
        description: 'Premium noise-canceling headphones',
        imageUrl: 'https://images.unsplash.com/photo-1545127398-14699f92334b?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_speaker_bluetooth',
        name: 'Bluetooth Speaker',
        categoryId: 'cat_audio',
        price: 79.99,
        description: 'Portable waterproof speaker with 12-hour battery',
        imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Men's Clothing
      ProductHive(
        id: 'prod_tshirt_mens',
        name: "Men's Cotton T-Shirt",
        categoryId: 'cat_mens',
        price: 19.99,
        description: '100% cotton, available in multiple colors',
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_jeans',
        name: 'Slim Fit Jeans',
        categoryId: 'cat_mens',
        price: 49.99,
        description: 'Classic blue denim jeans, slim fit',
        imageUrl: 'https://images.unsplash.com/photo-1542272454315-7ad96ca4bd76?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_shirt_formal',
        name: 'Formal Dress Shirt',
        categoryId: 'cat_mens',
        price: 39.99,
        description: 'White cotton formal shirt for office wear',
        imageUrl: 'https://images.unsplash.com/photo-1602810318660-d2c46b4f14a3?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_jacket',
        name: 'Leather Jacket',
        categoryId: 'cat_mens',
        price: 149.99,
        description: 'Genuine leather jacket, black',
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Women's Clothing
      ProductHive(
        id: 'prod_dress',
        name: 'Summer Dress',
        categoryId: 'cat_womens',
        price: 59.99,
        description: 'Floral print summer dress',
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_blouse',
        name: 'Silk Blouse',
        categoryId: 'cat_womens',
        price: 44.99,
        description: 'Elegant silk blouse for formal occasions',
        imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),
      ProductHive(
        id: 'prod_skirt',
        name: 'Pleated Skirt',
        categoryId: 'cat_womens',
        price: 34.99,
        description: 'Classic pleated midi skirt',
        imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=400',
        isAvailable: true,
        unit: 'pcs',
      ),

      // Footwear
      ProductHive(
        id: 'prod_sneakers',
        name: 'Running Sneakers',
        categoryId: 'cat_footwear',
        price: 89.99,
        description: 'Comfortable running shoes with cushioned sole',
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        isAvailable: true,
        unit: 'pair',
      ),
      ProductHive(
        id: 'prod_boots',
        name: 'Leather Boots',
        categoryId: 'cat_footwear',
        price: 129.99,
        description: 'Premium leather boots for winter',
        imageUrl: 'https://images.unsplash.com/photo-1605812860427-4024433a70fd?w=400',
        isAvailable: true,
        unit: 'pair',
      ),
      ProductHive(
        id: 'prod_sandals',
        name: 'Summer Sandals',
        categoryId: 'cat_footwear',
        price: 39.99,
        description: 'Comfortable casual sandals',
        imageUrl: 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=400',
        isAvailable: true,
        unit: 'pair',
      ),
      ProductHive(
        id: 'prod_heels',
        name: 'High Heels',
        categoryId: 'cat_footwear',
        price: 79.99,
        description: 'Elegant high heels for formal wear',
        imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400',
        isAvailable: true,
        unit: 'pair',
      ),
    ];
  }

  /// Clear all data
  static Future<void> clearAllData() async {
    await DatabaseService.getCategoriesBox().clear();
    await DatabaseService.getProductsBox().clear();
    await DatabaseService.clearCart();
  }
}
