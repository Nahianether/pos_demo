import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pos_riverpod_provider.dart';
import '../widgets/category_grid_riverpod.dart';
import '../widgets/product_grid_riverpod.dart';
import '../widgets/cart_panel_riverpod.dart';
import '../widgets/category_breadcrumb_riverpod.dart';

class POSScreenRiverpod extends ConsumerStatefulWidget {
  const POSScreenRiverpod({super.key});

  @override
  ConsumerState<POSScreenRiverpod> createState() => _POSScreenRiverpodState();
}

class _POSScreenRiverpodState extends ConsumerState<POSScreenRiverpod> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    ref.read(isRefreshingProvider.notifier).state = true;

    await Future.wait([
      ref.read(categoriesProvider.notifier).refresh(),
      ref.read(productsProvider.notifier).refresh(),
    ]);

    ref.read(isRefreshingProvider.notifier).state = false;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data refreshed successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF27AE60),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRefreshing = ref.watch(isRefreshingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          // Left Panel - Categories and Products
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _buildTopBar(isRefreshing),
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
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: const CartPanelRiverpod(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isRefreshing) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              const SizedBox(width: 12),
              if (isRefreshing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              const Spacer(),
              _buildRefreshButton(),
              const SizedBox(width: 8),
              _buildSearchBar(),
              const SizedBox(width: 16),
              _buildIconButton(Icons.settings, () {}),
              const SizedBox(width: 8),
              _buildIconButton(Icons.person, () {}),
            ],
          ),
          const SizedBox(height: 16),
          const CategoryBreadcrumbRiverpod(),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return InkWell(
      onTap: _refreshData,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF27AE60).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF27AE60).withValues(alpha: 0.3)),
        ),
        child: const Icon(Icons.refresh, color: Color(0xFF27AE60)),
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
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF3498DB),
      child: selectedCategoryId == null
          ? const CategoryGridRiverpod()
          : Consumer(
              builder: (context, ref, _) {
                final subCategories = ref.watch(subCategoriesProvider(selectedCategoryId));

                if (subCategories.isNotEmpty) {
                  return const CategoryGridRiverpod();
                } else {
                  return const ProductGridRiverpod();
                }
              },
            ),
    );
  }

  Widget _buildSearchResults() {
    final products = ref.watch(searchResultsProvider(_searchController.text));

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

    return ProductGridRiverpod(products: products);
  }
}
