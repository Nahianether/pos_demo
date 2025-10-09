import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../widgets/category_grid.dart';
import '../widgets/product_grid.dart';
import '../widgets/cart_panel.dart';
import '../widgets/category_breadcrumb.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Left Panel - Categories and Products
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults()
                      : _buildMainContent(),
                ),
              ],
            ),
          ),

          // Right Panel - Cart
          Container(
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: const CartPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'POS System',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const Spacer(),
              _buildSearchBar(),
              const SizedBox(width: 16),
              _buildIconButton(Icons.settings, () {}),
              const SizedBox(width: 8),
              _buildIconButton(Icons.person, () {}),
            ],
          ),
          const SizedBox(height: 16),
          const CategoryBreadcrumb(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF95A5A6)),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF95A5A6)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Icon(icon, color: const Color(0xFF34495E)),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        if (provider.selectedCategoryId == null) {
          return const CategoryGrid();
        }

        final subCategories = provider.getSubCategories(provider.selectedCategoryId!);

        if (subCategories.isNotEmpty) {
          return const CategoryGrid();
        } else {
          return const ProductGrid();
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final products = provider.searchProducts(_searchController.text);

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No products found',
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

        return ProductGrid(products: products);
      },
    );
  }
}
