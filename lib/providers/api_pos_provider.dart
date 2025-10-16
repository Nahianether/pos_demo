import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_hive.dart';
import '../models/category_hive.dart';
import '../models/cart_item_hive.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';

// API Connection Status Provider
final apiConnectionProvider = StateNotifierProvider<ApiConnectionNotifier, bool>((ref) {
  return ApiConnectionNotifier();
});

class ApiConnectionNotifier extends StateNotifier<bool> {
  ApiConnectionNotifier() : super(false) {
    checkConnection();
  }

  Future<void> checkConnection() async {
    state = await ApiService.checkConnection();
  }
}

// ==================== PRODUCTS ====================

final apiProductsProvider = StateNotifierProvider<ApiProductsNotifier, AsyncValue<List<ProductHive>>>((ref) {
  return ApiProductsNotifier();
});

class ApiProductsNotifier extends StateNotifier<AsyncValue<List<ProductHive>>> {
  ApiProductsNotifier() : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiProducts = await ApiService.getProducts(isActive: true);
      return _convertApiProductsToHive(apiProducts);
    });
  }

  Future<void> refresh() async {
    await loadProducts();
  }

  List<ProductHive> _convertApiProductsToHive(List<ApiProduct> apiProducts) {
    return apiProducts.map((api) => ProductHive(
      id: api.id,
      name: api.name,
      categoryId: api.categoryId ?? '',
      price: api.price,
      description: api.description,
      imageUrl: api.imageUrl,
      isAvailable: api.isActive,
      unit: null, // Not in API model
      lastUpdated: api.updatedAt,
      stockQuantity: api.stockQuantity,
    )).toList();
  }

  List<ProductHive> searchProducts(String query) {
    return state.when(
      data: (products) => products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  List<ProductHive> getProductsByCategory(String categoryId, List<CategoryHive> allCategories) {
    return state.when(
      data: (products) {
        final categoryIds = _getAllSubCategoryIds(categoryId, allCategories);
        categoryIds.add(categoryId);
        return products
            .where((p) => categoryIds.contains(p.categoryId) && p.isAvailable)
            .toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );
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
}

// ==================== CATEGORIES ====================

final apiCategoriesProvider = StateNotifierProvider<ApiCategoriesNotifier, AsyncValue<List<CategoryHive>>>((ref) {
  return ApiCategoriesNotifier();
});

class ApiCategoriesNotifier extends StateNotifier<AsyncValue<List<CategoryHive>>> {
  ApiCategoriesNotifier() : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiCategories = await ApiService.getCategories();
      return _convertApiCategoriesToHive(apiCategories);
    });
  }

  Future<void> refresh() async {
    await loadCategories();
  }

  List<CategoryHive> _convertApiCategoriesToHive(List<ApiCategory> apiCategories) {
    // Map categories with default values for icon, color, and level
    final Map<String, int> levels = {};

    // Calculate levels
    void calculateLevel(String id, List<ApiCategory> cats) {
      final cat = cats.firstWhere((c) => c.id == id);
      if (cat.parentId == null) {
        levels[id] = 0;
      } else {
        if (!levels.containsKey(cat.parentId!)) {
          calculateLevel(cat.parentId!, cats);
        }
        levels[id] = levels[cat.parentId!]! + 1;
      }
    }

    for (var cat in apiCategories) {
      if (!levels.containsKey(cat.id)) {
        calculateLevel(cat.id, apiCategories);
      }
    }

    // Default icons and colors
    final defaultIcons = ['restaurant', 'local_cafe', 'cake', 'fastfood', 'icecream'];
    final defaultColors = ['#3498DB', '#E74C3C', '#27AE60', '#F39C12', '#9B59B6'];

    return apiCategories.asMap().entries.map((entry) {
      final index = entry.key;
      final api = entry.value;
      return CategoryHive(
        id: api.id,
        name: api.name,
        parentId: api.parentId,
        icon: defaultIcons[index % defaultIcons.length],
        color: defaultColors[index % defaultColors.length],
        level: levels[api.id] ?? 0,
      );
    }).toList();
  }
}

// ==================== CART ====================

final apiCartIdProvider = StateProvider<String?>((ref) => null);

final apiCartProvider = StateNotifierProvider<ApiCartNotifier, AsyncValue<List<CartItemHive>>>((ref) {
  return ApiCartNotifier(ref);
});

class ApiCartNotifier extends StateNotifier<AsyncValue<List<CartItemHive>>> {
  final Ref ref;

  ApiCartNotifier(this.ref) : super(const AsyncValue.data([]));

  Future<void> addToCart(ProductHive product) async {
    try {
      print('🛒 Adding to cart: ${product.name} (ID: ${product.id})');

      // Get or create cart ID
      String? cartId = ref.read(apiCartIdProvider);
      print('🛒 Current cart ID: $cartId');

      if (cartId == null) {
        print('🛒 Creating new cart...');
        final cart = await ApiService.createCart();
        cartId = cart.id;
        ref.read(apiCartIdProvider.notifier).state = cartId;
        print('🛒 New cart created: $cartId');
      }

      // Add item to cart
      print('🛒 Adding item to cart via API...');
      final cartWithItems = await ApiService.addToCart(
        cartId: cartId,
        productId: product.id,
        quantity: 1,
      );

      print('🛒 API Response: ${cartWithItems.items.length} items in cart');
      for (var item in cartWithItems.items) {
        print('   - ${item.productName} x${item.quantity}');
      }

      // Convert to CartItemHive
      final cartItems = _convertApiCartItems(cartWithItems.items);
      print('🛒 Setting cart state with ${cartItems.length} items');
      state = AsyncValue.data(cartItems);
    } catch (e, stack) {
      print('❌ Error adding to cart: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final cartId = ref.read(apiCartIdProvider);
    if (cartId == null) return;

    try {
      if (quantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      // Get the cart to find the item ID
      final cartWithItems = await ApiService.getCart(cartId);
      final apiItem = cartWithItems.items.firstWhere((i) => i.productId == productId);

      final updatedCart = await ApiService.updateCartItem(
        cartId: cartId,
        itemId: apiItem.id,
        quantity: quantity,
      );

      state = AsyncValue.data(_convertApiCartItems(updatedCart.items));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeFromCart(String productId) async {
    final cartId = ref.read(apiCartIdProvider);
    if (cartId == null) return;

    try {
      final cartWithItems = await ApiService.getCart(cartId);
      final apiItem = cartWithItems.items.firstWhere((i) => i.productId == productId);

      final updatedCart = await ApiService.removeFromCart(
        cartId: cartId,
        itemId: apiItem.id,
      );

      state = AsyncValue.data(_convertApiCartItems(updatedCart.items));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearCart() async {
    final cartId = ref.read(apiCartIdProvider);
    if (cartId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      await ApiService.clearCart(cartId);
      ref.read(apiCartIdProvider.notifier).state = null;
      state = const AsyncValue.data([]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  List<CartItemHive> _convertApiCartItems(List<ApiCartItem> apiItems) {
    return apiItems.map((api) => CartItemHive(
      product: ProductHive(
        id: api.productId,
        name: api.productName,
        categoryId: '',
        price: api.unitPrice,
        isAvailable: true,
        lastUpdated: DateTime.now(),
        stockQuantity: 0, // Stock info not in cart item response
      ),
      quantity: api.quantity,
    )).toList();
  }
}

// ==================== HELPER PROVIDERS ====================

final apiRootCategoriesProvider = Provider<List<CategoryHive>>((ref) {
  return ref.watch(apiCategoriesProvider).when(
    data: (categories) => categories.where((cat) => cat.parentId == null).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final apiSubCategoriesProvider = Provider.family<List<CategoryHive>, String>((ref, parentId) {
  return ref.watch(apiCategoriesProvider).when(
    data: (categories) => categories.where((cat) => cat.parentId == parentId).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final apiProductsByCategoryProvider = Provider.family<List<ProductHive>, String>((ref, categoryId) {
  final products = ref.watch(apiProductsProvider);
  final categories = ref.watch(apiCategoriesProvider);

  return products.when(
    data: (prods) {
      return categories.when(
        data: (cats) => ref.read(apiProductsProvider.notifier).getProductsByCategory(categoryId, cats),
        loading: () => [],
        error: (_, __) => [],
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final apiSearchResultsProvider = Provider.family<List<ProductHive>, String>((ref, query) {
  final products = ref.watch(apiProductsProvider);
  return products.when(
    data: (prods) => ref.read(apiProductsProvider.notifier).searchProducts(query),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ==================== SETTINGS ====================

final apiBaseUrlProvider = StateProvider<String>((ref) {
  return ApiService.baseUrl;
});

// Provider to set API base URL
final setApiBaseUrlProvider = Provider<void Function(String)>((ref) {
  return (String url) {
    ApiService.setBaseUrl(url);
    ref.read(apiBaseUrlProvider.notifier).state = url;
    // Reload data
    ref.read(apiProductsProvider.notifier).loadProducts();
    ref.read(apiCategoriesProvider.notifier).loadCategories();
    ref.read(apiConnectionProvider.notifier).checkConnection();
  };
});
