import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../data/sample_data.dart';

class POSProvider with ChangeNotifier {
  List<models.Category> _categories = [];
  List<Product> _products = [];
  final List<CartItem> _cartItems = [];
  String? _selectedCategoryId;
  final List<String> _categoryPath = [];

  POSProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _categories = SampleData.categories;
    _products = SampleData.products;
    notifyListeners();
  }

  // Getters
  List<models.Category> get categories => _categories;
  List<Product> get products => _products;
  List<CartItem> get cartItems => _cartItems;
  String? get selectedCategoryId => _selectedCategoryId;
  List<String> get categoryPath => _categoryPath;

  double get cartTotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get cartItemsCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Category Navigation
  List<models.Category> getRootCategories() {
    return _categories.where((cat) => cat.parentId == null).toList();
  }

  List<models.Category> getSubCategories(String parentId) {
    return _categories.where((cat) => cat.parentId == parentId).toList();
  }

  models.Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _buildCategoryPath(categoryId);
    notifyListeners();
  }

  void _buildCategoryPath(String categoryId) {
    _categoryPath.clear();
    String? currentId = categoryId;

    while (currentId != null) {
      _categoryPath.insert(0, currentId);
      final category = getCategoryById(currentId);
      currentId = category?.parentId;
    }
  }

  void navigateBack() {
    if (_categoryPath.length > 1) {
      _categoryPath.removeLast();
      _selectedCategoryId = _categoryPath.last;
    } else {
      _selectedCategoryId = null;
      _categoryPath.clear();
    }
    notifyListeners();
  }

  void resetNavigation() {
    _selectedCategoryId = null;
    _categoryPath.clear();
    notifyListeners();
  }

  // Product Filtering
  List<Product> getProductsByCategory(String categoryId) {
    // Get all subcategory IDs recursively
    final categoryIds = _getAllSubCategoryIds(categoryId);
    categoryIds.add(categoryId);

    return _products.where((product) =>
      categoryIds.contains(product.categoryId) && product.isAvailable
    ).toList();
  }

  List<String> _getAllSubCategoryIds(String parentId) {
    final List<String> ids = [];
    final subCategories = getSubCategories(parentId);

    for (var cat in subCategories) {
      ids.add(cat.id);
      ids.addAll(_getAllSubCategoryIds(cat.id));
    }

    return ids;
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    return _products.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) &&
      product.isAvailable
    ).toList();
  }

  // Cart Management
  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartItemQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.product.id == productId
    );

    if (index >= 0) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Order Processing
  Order? processOrder({
    required PaymentMethod paymentMethod,
    String? customerName,
    double discount = 0.0,
  }) {
    if (_cartItems.isEmpty) return null;

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(_cartItems),
      createdAt: DateTime.now(),
      totalAmount: cartTotal,
      tax: cartTotal * 0.0, // You can add tax calculation
      discount: discount,
      paymentMethod: paymentMethod,
      customerName: customerName,
    );

    clearCart();
    return order;
  }
}
