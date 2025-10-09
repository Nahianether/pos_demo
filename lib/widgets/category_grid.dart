import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../models/category.dart' as models;

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final categories = provider.selectedCategoryId == null
            ? provider.getRootCategories()
            : provider.getSubCategories(provider.selectedCategoryId!);

        if (categories.isEmpty) {
          return const Center(
            child: Text('No categories available'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _CategoryCard(category: categories[index]);
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final models.Category category;

  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('FF${widget.category.color}', radix: 16));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          context.read<POSProvider>().selectCategory(widget.category.id);
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? color : color.withOpacity(0.3),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: color.withOpacity(_isHovered ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    widget.category.icon,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Consumer<POSProvider>(
                builder: (context, provider, _) {
                  final subCategories = provider.getSubCategories(widget.category.id);
                  if (subCategories.isNotEmpty) {
                    return Text(
                      '${subCategories.length} subcategories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    );
                  }

                  final products = provider.getProductsByCategory(widget.category.id);
                  return Text(
                    '${products.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
