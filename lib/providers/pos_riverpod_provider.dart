import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_hive.dart';
import '../models/product_hive.dart';
import '../models/cart_item_hive.dart';
import '../services/database_service.dart';
import 'settings_provider.dart';

// Categories Provider
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<CategoryHive>>((ref) {
  final settings = ref.watch(settingsProvider);
  return CategoriesNotifier(settings.isApiMode);
});

class CategoriesNotifier extends StateNotifier<List<CategoryHive>> {
  final bool isApiMode;

  CategoriesNotifier(this.isApiMode) : super([]) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    var categories = DatabaseService.getAllCategories();
    // Don't load dummy data - only use server data
    state = categories;
  }

  Future<void> refresh() async {
    // Reload categories from database (no dummy data)
    await Future.delayed(const Duration(milliseconds: 500));
    final categories = DatabaseService.getAllCategories();
    state = categories;
  }
}

// Products Provider
final productsProvider = StateNotifierProvider<ProductsNotifier, List<ProductHive>>((ref) {
  final settings = ref.watch(settingsProvider);
  return ProductsNotifier(settings.isApiMode);
});

class ProductsNotifier extends StateNotifier<List<ProductHive>> {
  final bool isApiMode;

  ProductsNotifier(this.isApiMode) : super([]) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    var products = DatabaseService.getAllProducts();
    // Don't load dummy data - only use server data
    state = products;
  }

  Future<void> refresh() async {
    // Reload products from database (no dummy data)
    await Future.delayed(const Duration(milliseconds: 500));
    final products = DatabaseService.getAllProducts();
    state = products;
  }

  List<ProductHive> getProductsByCategory(String categoryId, List<CategoryHive> allCategories) {
    // Get all subcategory IDs recursively
    final categoryIds = _getAllSubCategoryIds(categoryId, allCategories);
    categoryIds.add(categoryId);

    return state.where((product) =>
      categoryIds.contains(product.categoryId) && product.isAvailable
    ).toList();
  }

  List<String> _getAllSubCategoryIds(String parentId, List<CategoryHive> allCategories) {
    final List<String> ids = [];
    final subCategories = allCategories.where((cat) => cat.parentId == parentId).toList();

    for (var cat in subCategories) {
      ids.add(cat.id);
      ids.addAll(_getAllSubCategoryIds(cat.id, allCategories));
    }

    return ids;
  }

  List<ProductHive> searchProducts(String query) {
    if (query.isEmpty) return [];

    return state.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) &&
      product.isAvailable
    ).toList();
  }

  Future<void> addProduct(ProductHive product) async {
    await DatabaseService.getProductsBox().put(product.id, product);
    state = [...state, product];
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemHive>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItemHive>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = DatabaseService.getCartItems();
  }

  Future<void> addToCart(ProductHive product) async {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id
    );

    if (existingIndex >= 0) {
      final updatedItem = state[existingIndex];
      updatedItem.quantity++;
      await DatabaseService.addToCart(updatedItem);
    } else {
      final newItem = CartItemHive(product: product, quantity: 1);
      await DatabaseService.addToCart(newItem);
    }

    state = DatabaseService.getCartItems();
  }

  Future<void> removeFromCart(String productId) async {
    await DatabaseService.removeFromCart(productId);
    state = DatabaseService.getCartItems();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    await DatabaseService.updateCartItemQuantity(productId, quantity);
    state = DatabaseService.getCartItems();
  }

  Future<void> clearCart() async {
    await DatabaseService.clearCart();
    state = [];
  }

  double get cartTotal {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get cartItemsCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Category Path Provider
final categoryPathProvider = StateProvider<List<String>>((ref) => []);

// Helper providers
final rootCategoriesProvider = Provider<List<CategoryHive>>((ref) {
  final categories = ref.watch(categoriesProvider);
  return categories.where((cat) => cat.parentId == null).toList();
});

final subCategoriesProvider = Provider.family<List<CategoryHive>, String>((ref, parentId) {
  final categories = ref.watch(categoriesProvider);
  return categories.where((cat) => cat.parentId == parentId).toList();
});

final categoryByIdProvider = Provider.family<CategoryHive?, String>((ref, id) {
  final categories = ref.watch(categoriesProvider);
  try {
    return categories.firstWhere((cat) => cat.id == id);
  } catch (e) {
    return null;
  }
});

final productsByCategoryProvider = Provider.family<List<ProductHive>, String>((ref, categoryId) {
  final productsNotifier = ref.watch(productsProvider.notifier);
  final categories = ref.watch(categoriesProvider);
  return productsNotifier.getProductsByCategory(categoryId, categories);
});

final searchResultsProvider = Provider.family<List<ProductHive>, String>((ref, query) {
  final productsNotifier = ref.watch(productsProvider.notifier);
  return productsNotifier.searchProducts(query);
});

// Basic cart calculations (for backward compatibility)
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartFinalTotalProvider);
});

final cartItemsCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});

// Loading state provider
final isRefreshingProvider = StateProvider<bool>((ref) => false);
