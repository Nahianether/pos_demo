import '../models/category.dart';
import '../models/product.dart';

class SampleData {
  static final List<Category> categories = [
    // Level 1 - Main Categories
    Category(
      id: 'food',
      name: 'Food',
      icon: '🍽️',
      color: 'FF6B6B',
      level: 1,
    ),
    Category(
      id: 'beverages',
      name: 'Beverages',
      icon: '☕',
      color: '4ECDC4',
      level: 1,
    ),
    Category(
      id: 'groceries',
      name: 'Groceries',
      icon: '🛒',
      color: 'FFE66D',
      level: 1,
    ),

    // Level 2 - Food Subcategories
    Category(
      id: 'hot_meals',
      name: 'Hot Meals',
      parentId: 'food',
      icon: '🍲',
      color: 'FF8B94',
      level: 2,
    ),
    Category(
      id: 'snacks',
      name: 'Snacks',
      parentId: 'food',
      icon: '🍿',
      color: 'FFB6B9',
      level: 2,
    ),
    Category(
      id: 'desserts',
      name: 'Desserts',
      parentId: 'food',
      icon: '🍰',
      color: 'FEC8D8',
      level: 2,
    ),

    // Level 3 - Hot Meals Subcategories
    Category(
      id: 'rice_dishes',
      name: 'Rice Dishes',
      parentId: 'hot_meals',
      icon: '🍚',
      color: 'FFA5A5',
      level: 3,
    ),
    Category(
      id: 'pasta',
      name: 'Pasta',
      parentId: 'hot_meals',
      icon: '🍝',
      color: 'FFB3B3',
      level: 3,
    ),
    Category(
      id: 'grilled',
      name: 'Grilled',
      parentId: 'hot_meals',
      icon: '🥩',
      color: 'FFC1C1',
      level: 3,
    ),

    // Level 2 - Beverage Subcategories
    Category(
      id: 'hot_drinks',
      name: 'Hot Drinks',
      parentId: 'beverages',
      icon: '☕',
      color: '95E1D3',
      level: 2,
    ),
    Category(
      id: 'cold_drinks',
      name: 'Cold Drinks',
      parentId: 'beverages',
      icon: '🥤',
      color: 'A8E6CF',
      level: 2,
    ),
    Category(
      id: 'juices',
      name: 'Fresh Juices',
      parentId: 'beverages',
      icon: '🧃',
      color: 'B8E6D5',
      level: 2,
    ),

    // Level 2 - Grocery Subcategories
    Category(
      id: 'dairy',
      name: 'Dairy',
      parentId: 'groceries',
      icon: '🥛',
      color: 'FFF4A3',
      level: 2,
    ),
    Category(
      id: 'bakery',
      name: 'Bakery',
      parentId: 'groceries',
      icon: '🥖',
      color: 'FFF7B3',
      level: 2,
    ),
    Category(
      id: 'vegetables',
      name: 'Vegetables',
      parentId: 'groceries',
      icon: '🥬',
      color: 'FFFAC3',
      level: 2,
    ),
    Category(
      id: 'fruits',
      name: 'Fruits',
      parentId: 'groceries',
      icon: '🍎',
      color: 'FFFDD3',
      level: 2,
    ),
  ];

  static final List<Product> products = [
    // Rice Dishes
    Product(
      id: 'p1',
      name: 'Chicken Biryani',
      categoryId: 'rice_dishes',
      price: 12.99,
      description: 'Aromatic basmati rice with tender chicken',
      unit: 'plate',
    ),
    Product(
      id: 'p2',
      name: 'Fried Rice',
      categoryId: 'rice_dishes',
      price: 8.99,
      description: 'Classic fried rice with vegetables',
      unit: 'plate',
    ),
    Product(
      id: 'p3',
      name: 'Vegetable Pulao',
      categoryId: 'rice_dishes',
      price: 7.99,
      description: 'Fragrant rice with mixed vegetables',
      unit: 'plate',
    ),

    // Pasta
    Product(
      id: 'p4',
      name: 'Spaghetti Carbonara',
      categoryId: 'pasta',
      price: 11.99,
      description: 'Creamy pasta with bacon and parmesan',
      unit: 'plate',
    ),
    Product(
      id: 'p5',
      name: 'Penne Arrabiata',
      categoryId: 'pasta',
      price: 10.99,
      description: 'Spicy tomato sauce pasta',
      unit: 'plate',
    ),

    // Grilled
    Product(
      id: 'p6',
      name: 'Grilled Chicken Breast',
      categoryId: 'grilled',
      price: 14.99,
      description: 'Marinated grilled chicken with herbs',
      unit: 'piece',
    ),
    Product(
      id: 'p7',
      name: 'BBQ Ribs',
      categoryId: 'grilled',
      price: 18.99,
      description: 'Tender ribs with BBQ sauce',
      unit: 'portion',
    ),

    // Snacks
    Product(
      id: 'p8',
      name: 'French Fries',
      categoryId: 'snacks',
      price: 4.99,
      description: 'Crispy golden fries',
      unit: 'portion',
    ),
    Product(
      id: 'p9',
      name: 'Chicken Wings',
      categoryId: 'snacks',
      price: 9.99,
      description: 'Spicy buffalo wings',
      unit: '6 pcs',
    ),
    Product(
      id: 'p10',
      name: 'Spring Rolls',
      categoryId: 'snacks',
      price: 5.99,
      description: 'Vegetable spring rolls',
      unit: '4 pcs',
    ),

    // Desserts
    Product(
      id: 'p11',
      name: 'Chocolate Cake',
      categoryId: 'desserts',
      price: 6.99,
      description: 'Rich chocolate layer cake',
      unit: 'slice',
    ),
    Product(
      id: 'p12',
      name: 'Ice Cream',
      categoryId: 'desserts',
      price: 4.99,
      description: 'Vanilla ice cream',
      unit: 'scoop',
    ),
    Product(
      id: 'p13',
      name: 'Tiramisu',
      categoryId: 'desserts',
      price: 7.99,
      description: 'Italian coffee-flavored dessert',
      unit: 'portion',
    ),

    // Hot Drinks
    Product(
      id: 'p14',
      name: 'Espresso',
      categoryId: 'hot_drinks',
      price: 3.99,
      description: 'Strong Italian coffee',
      unit: 'cup',
    ),
    Product(
      id: 'p15',
      name: 'Cappuccino',
      categoryId: 'hot_drinks',
      price: 4.99,
      description: 'Coffee with steamed milk foam',
      unit: 'cup',
    ),
    Product(
      id: 'p16',
      name: 'Hot Chocolate',
      categoryId: 'hot_drinks',
      price: 4.49,
      description: 'Rich hot chocolate',
      unit: 'cup',
    ),
    Product(
      id: 'p17',
      name: 'Green Tea',
      categoryId: 'hot_drinks',
      price: 2.99,
      description: 'Organic green tea',
      unit: 'cup',
    ),

    // Cold Drinks
    Product(
      id: 'p18',
      name: 'Coca Cola',
      categoryId: 'cold_drinks',
      price: 2.49,
      description: 'Classic cola',
      unit: '330ml',
    ),
    Product(
      id: 'p19',
      name: 'Sprite',
      categoryId: 'cold_drinks',
      price: 2.49,
      description: 'Lemon-lime soda',
      unit: '330ml',
    ),
    Product(
      id: 'p20',
      name: 'Iced Coffee',
      categoryId: 'cold_drinks',
      price: 4.99,
      description: 'Cold brew coffee',
      unit: 'glass',
    ),

    // Juices
    Product(
      id: 'p21',
      name: 'Orange Juice',
      categoryId: 'juices',
      price: 5.99,
      description: 'Freshly squeezed orange juice',
      unit: 'glass',
    ),
    Product(
      id: 'p22',
      name: 'Mango Smoothie',
      categoryId: 'juices',
      price: 6.99,
      description: 'Fresh mango smoothie',
      unit: 'glass',
    ),
    Product(
      id: 'p23',
      name: 'Mixed Berry Juice',
      categoryId: 'juices',
      price: 6.49,
      description: 'Blend of fresh berries',
      unit: 'glass',
    ),

    // Dairy
    Product(
      id: 'p24',
      name: 'Fresh Milk',
      categoryId: 'dairy',
      price: 3.99,
      description: 'Full cream milk',
      unit: '1L',
    ),
    Product(
      id: 'p25',
      name: 'Greek Yogurt',
      categoryId: 'dairy',
      price: 4.99,
      description: 'Natural Greek yogurt',
      unit: '500g',
    ),
    Product(
      id: 'p26',
      name: 'Cheddar Cheese',
      categoryId: 'dairy',
      price: 7.99,
      description: 'Aged cheddar',
      unit: '250g',
    ),

    // Bakery
    Product(
      id: 'p27',
      name: 'Baguette',
      categoryId: 'bakery',
      price: 2.99,
      description: 'Fresh French bread',
      unit: 'piece',
    ),
    Product(
      id: 'p28',
      name: 'Croissant',
      categoryId: 'bakery',
      price: 3.49,
      description: 'Buttery croissant',
      unit: 'piece',
    ),
    Product(
      id: 'p29',
      name: 'Whole Wheat Bread',
      categoryId: 'bakery',
      price: 3.99,
      description: 'Healthy whole wheat loaf',
      unit: 'loaf',
    ),

    // Vegetables
    Product(
      id: 'p30',
      name: 'Tomatoes',
      categoryId: 'vegetables',
      price: 2.99,
      description: 'Fresh red tomatoes',
      unit: 'kg',
    ),
    Product(
      id: 'p31',
      name: 'Lettuce',
      categoryId: 'vegetables',
      price: 1.99,
      description: 'Crisp green lettuce',
      unit: 'head',
    ),
    Product(
      id: 'p32',
      name: 'Carrots',
      categoryId: 'vegetables',
      price: 2.49,
      description: 'Organic carrots',
      unit: 'kg',
    ),

    // Fruits
    Product(
      id: 'p33',
      name: 'Apples',
      categoryId: 'fruits',
      price: 4.99,
      description: 'Red delicious apples',
      unit: 'kg',
    ),
    Product(
      id: 'p34',
      name: 'Bananas',
      categoryId: 'fruits',
      price: 2.99,
      description: 'Fresh bananas',
      unit: 'kg',
    ),
    Product(
      id: 'p35',
      name: 'Strawberries',
      categoryId: 'fruits',
      price: 6.99,
      description: 'Sweet strawberries',
      unit: '250g',
    ),
  ];
}
