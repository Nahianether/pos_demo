import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pos_provider.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product>? products;

  const ProductGrid({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final productList = products ??
            (provider.selectedCategoryId != null
                ? provider.getProductsByCategory(provider.selectedCategoryId!)
                : []);

        if (productList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No products available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return _ProductCard(product: productList[index]);
          },
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          context.read<POSProvider>().addToCart(widget.product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.product.name} added to cart'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF27AE60),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? const Color(0xFF3498DB) : const Color(0xFFE0E0E0),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF3498DB).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Placeholder
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3498DB).withOpacity(0.1),
                      const Color(0xFF9B59B6).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.product.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.product.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currencyFormat.format(widget.product.price),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF27AE60),
                                ),
                              ),
                              if (widget.product.unit != null)
                                Text(
                                  widget.product.unit!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3498DB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
