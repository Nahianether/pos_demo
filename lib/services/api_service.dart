import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class ApiService {
  // Base URL - can be configured via settings
  static String _baseUrl = 'http://localhost:3000/api';

  // Getters for different environments
  static String get localhost => 'http://localhost:3000/api';
  static String get androidEmulator => 'http://10.0.2.2:3000/api';

  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  static String get baseUrl => _baseUrl;

  // Helper method to handle API responses
  static Future<T> _handleResponse<T>(
    Future<http.Response> Function() request,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final response = await request();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          throw Exception('Empty response from server');
        }
        final dynamic data = json.decode(response.body);
        return fromJson(data);
      } else {
        final error = response.body;
        throw Exception('API Error (${response.statusCode}): $error');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  // ==================== PRODUCTS API ====================

  /// Get all products with optional filters
  static Future<List<ApiProduct>> getProducts({
    String? search,
    String? categoryId,
    bool? isActive,
  }) async {
    final queryParams = <String, String>{};
    if (search != null) queryParams['search'] = search;
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (isActive != null) queryParams['is_active'] = isActive.toString();

    final uri = Uri.parse('$_baseUrl/products').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    return _handleResponse(
      () => http.get(uri),
      (data) => (data as List).map((item) => ApiProduct.fromJson(item)).toList(),
    );
  }

  /// Get single product by ID
  static Future<ApiProduct> getProduct(String id) async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/products/$id')),
      (data) => ApiProduct.fromJson(data),
    );
  }

  // ==================== CATEGORIES API ====================

  /// Get all categories
  static Future<List<ApiCategory>> getCategories() async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/categories')),
      (data) => (data as List).map((item) => ApiCategory.fromJson(item)).toList(),
    );
  }

  /// Get single category by ID
  static Future<ApiCategory> getCategory(String id) async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/categories/$id')),
      (data) => ApiCategory.fromJson(data),
    );
  }

  // ==================== CART API ====================

  /// Create a new cart
  static Future<ApiCart> createCart({String? customerName}) async {
    return _handleResponse(
      () => http.post(
        Uri.parse('$_baseUrl/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'customer_name': customerName}),
      ),
      (data) => ApiCart.fromJson(data),
    );
  }

  /// Get cart with items
  static Future<ApiCartWithItems> getCart(String cartId) async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/carts/$cartId')),
      (data) => ApiCartWithItems.fromJson(data),
    );
  }

  /// Add item to cart
  static Future<ApiCartWithItems> addToCart({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    return _handleResponse(
      () => http.post(
        Uri.parse('$_baseUrl/carts/$cartId/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_id': productId,
          'quantity': quantity,
        }),
      ),
      (data) => ApiCartWithItems.fromJson(data),
    );
  }

  /// Update cart item quantity
  static Future<ApiCartWithItems> updateCartItem({
    required String cartId,
    required String itemId,
    required int quantity,
  }) async {
    return _handleResponse(
      () => http.put(
        Uri.parse('$_baseUrl/carts/$cartId/items/$itemId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': quantity}),
      ),
      (data) => ApiCartWithItems.fromJson(data),
    );
  }

  /// Remove item from cart
  static Future<ApiCartWithItems> removeFromCart({
    required String cartId,
    required String itemId,
  }) async {
    return _handleResponse(
      () => http.delete(Uri.parse('$_baseUrl/carts/$cartId/items/$itemId')),
      (data) => ApiCartWithItems.fromJson(data),
    );
  }

  /// Clear cart
  static Future<void> clearCart(String cartId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/carts/$cartId/clear'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to clear cart: ${response.body}');
    }
  }

  // ==================== SALES API ====================

  /// Complete a sale (checkout)
  static Future<ApiSaleWithItems> completeSale(CreateSaleRequest request) async {
    return _handleResponse(
      () => http.post(
        Uri.parse('$_baseUrl/sales'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      ),
      (data) => ApiSaleWithItems.fromJson(data),
    );
  }

  /// Get sales history
  static Future<List<ApiSale>> getSales({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    final uri = Uri.parse('$_baseUrl/sales').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    return _handleResponse(
      () => http.get(uri),
      (data) => (data as List).map((item) => ApiSale.fromJson(item)).toList(),
    );
  }

  /// Get single sale by ID
  static Future<ApiSaleWithItems> getSale(String id) async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/sales/$id')),
      (data) => ApiSaleWithItems.fromJson(data),
    );
  }

  /// Get sales summary
  static Future<SalesSummary> getSalesSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    final uri = Uri.parse('$_baseUrl/sales/summary').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    return _handleResponse(
      () => http.get(uri),
      (data) => SalesSummary.fromJson(data),
    );
  }

  // ==================== INVENTORY API ====================

  /// Check product stock
  static Future<ApiInventory> getProductInventory(String productId) async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/inventory/$productId')),
      (data) => ApiInventory.fromJson(data),
    );
  }

  /// Get low stock products
  static Future<List<LowStockProduct>> getLowStockProducts() async {
    return _handleResponse(
      () => http.get(Uri.parse('$_baseUrl/inventory/low-stock')),
      (data) => (data as List).map((item) => LowStockProduct.fromJson(item)).toList(),
    );
  }

  // ==================== HEALTH CHECK ====================

  /// Check if API is reachable
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/products'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
