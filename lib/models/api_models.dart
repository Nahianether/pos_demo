// API Models matching backend structure

class ApiProduct {
  final String id;
  final String name;
  final String? description;
  final String sku;
  final double price;
  final double? costPrice;
  final String? categoryId;
  final String? imageUrl;
  final bool isActive;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiProduct({
    required this.id,
    required this.name,
    this.description,
    required this.sku,
    required this.price,
    this.costPrice,
    this.categoryId,
    this.imageUrl,
    required this.isActive,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sku: json['sku'],
      price: (json['price'] as num).toDouble(),
      costPrice: json['cost_price'] != null
          ? (json['cost_price'] as num).toDouble()
          : null,
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      stockQuantity: json['stock_quantity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sku': sku,
      'price': price,
      'cost_price': costPrice,
      'category_id': categoryId,
      'image_url': imageUrl,
      'is_active': isActive,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ApiCategory {
  final String id;
  final String name;
  final String? description;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiCategory({
    required this.id,
    required this.name,
    this.description,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ApiCart {
  final String id;
  final String sessionId;
  final String? customerName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiCart({
    required this.id,
    required this.sessionId,
    this.customerName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiCart.fromJson(Map<String, dynamic> json) {
    return ApiCart(
      id: json['id'],
      sessionId: json['session_id'],
      customerName: json['customer_name'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ApiCartItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  ApiCartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory ApiCartItem.fromJson(Map<String, dynamic> json) {
    return ApiCartItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class ApiCartWithItems {
  final ApiCart cart;
  final List<ApiCartItem> items;
  final double total;

  ApiCartWithItems({
    required this.cart,
    required this.items,
    required this.total,
  });

  factory ApiCartWithItems.fromJson(Map<String, dynamic> json) {
    return ApiCartWithItems(
      cart: ApiCart.fromJson(json['cart']),
      items: (json['items'] as List)
          .map((item) => ApiCartItem.fromJson(item))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

enum PaymentMethod {
  Cash,
  Card,
  DigitalWallet,
  Other;

  String toApiString() {
    return name;
  }

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentMethod.Other,
    );
  }
}

class ApiSaleItem {
  final String productId;
  final int quantity;

  ApiSaleItem({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class CreateSaleRequest {
  final String? customerName;
  final String? cartId;
  final List<ApiSaleItem> items;
  final double? discount;
  final double? tax;
  final PaymentMethod paymentMethod;
  final double paymentReceived;
  final String? notes;

  CreateSaleRequest({
    this.customerName,
    this.cartId,
    required this.items,
    this.discount,
    this.tax,
    required this.paymentMethod,
    required this.paymentReceived,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (customerName != null) 'customer_name': customerName,
      if (cartId != null) 'cart_id': cartId,
      'items': items.map((item) => item.toJson()).toList(),
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      'payment_method': paymentMethod.toApiString(),
      'payment_received': paymentReceived,
      if (notes != null) 'notes': notes,
    };
  }
}

class ApiSale {
  final String id;
  final String? customerName;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String paymentMethod;
  final double paymentReceived;
  final double changeGiven;
  final String? notes;
  final DateTime createdAt;

  ApiSale({
    required this.id,
    this.customerName,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.paymentReceived,
    required this.changeGiven,
    this.notes,
    required this.createdAt,
  });

  factory ApiSale.fromJson(Map<String, dynamic> json) {
    return ApiSale(
      id: json['id'],
      customerName: json['customer_name'],
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      paymentReceived: (json['payment_received'] as num).toDouble(),
      changeGiven: (json['change_given'] as num).toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ApiSaleItemResponse {
  final String id;
  final String saleId;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final DateTime createdAt;

  ApiSaleItemResponse({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.createdAt,
  });

  factory ApiSaleItemResponse.fromJson(Map<String, dynamic> json) {
    return ApiSaleItemResponse(
      id: json['id'],
      saleId: json['sale_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ApiSaleWithItems {
  final ApiSale sale;
  final List<ApiSaleItemResponse> items;

  ApiSaleWithItems({
    required this.sale,
    required this.items,
  });

  factory ApiSaleWithItems.fromJson(Map<String, dynamic> json) {
    return ApiSaleWithItems(
      sale: ApiSale.fromJson(json['sale']),
      items: (json['items'] as List)
          .map((item) => ApiSaleItemResponse.fromJson(item))
          .toList(),
    );
  }
}

class ApiInventory {
  final String id;
  final String productId;
  final int quantity;
  final int minStockLevel;
  final int maxStockLevel;
  final String? location;
  final DateTime? lastRestockedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiInventory({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.minStockLevel,
    required this.maxStockLevel,
    this.location,
    this.lastRestockedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiInventory.fromJson(Map<String, dynamic> json) {
    return ApiInventory(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      minStockLevel: json['min_stock_level'],
      maxStockLevel: json['max_stock_level'],
      location: json['location'],
      lastRestockedAt: json['last_restocked_at'] != null
          ? DateTime.parse(json['last_restocked_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class SalesSummary {
  final int totalSales;
  final double totalRevenue;
  final double totalDiscount;
  final double totalTax;

  SalesSummary({
    required this.totalSales,
    required this.totalRevenue,
    required this.totalDiscount,
    required this.totalTax,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    return SalesSummary(
      totalSales: json['total_sales'],
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalDiscount: (json['total_discount'] as num).toDouble(),
      totalTax: (json['total_tax'] as num).toDouble(),
    );
  }
}

class LowStockProduct {
  final String productId;
  final String productName;
  final int currentQuantity;
  final int minStockLevel;

  LowStockProduct({
    required this.productId,
    required this.productName,
    required this.currentQuantity,
    required this.minStockLevel,
  });

  factory LowStockProduct.fromJson(Map<String, dynamic> json) {
    return LowStockProduct(
      productId: json['product_id'],
      productName: json['product_name'],
      currentQuantity: json['current_quantity'],
      minStockLevel: json['min_stock_level'],
    );
  }
}
