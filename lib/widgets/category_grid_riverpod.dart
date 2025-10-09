import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pos_riverpod_provider.dart';
import '../models/category_hive.dart';

class CategoryGridRiverpod extends ConsumerWidget {
  const CategoryGridRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryProvider);
    final categories = selectedCategoryId == null
        ? ref.watch(rootCategoriesProvider)
        : ref.watch(subCategoriesProvider(selectedCategoryId));

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
  }
}

class _CategoryCard extends ConsumerStatefulWidget {
  final CategoryHive category;

  const _CategoryCard({required this.category});

  @override
  ConsumerState<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends ConsumerState<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('FF${widget.category.color}', radix: 16));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          ref.read(selectedCategoryProvider.notifier).state = widget.category.id;
          final currentPath = ref.read(categoryPathProvider);
          ref.read(categoryPathProvider.notifier).state = [...currentPath, widget.category.id];
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? color : color.withValues(alpha: 0.3),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
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
                  color: color.withValues(alpha: _isHovered ? 0.15 : 0.1),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Consumer(
                builder: (context, ref, _) {
                  final subCategories = ref.watch(subCategoriesProvider(widget.category.id));
                  if (subCategories.isNotEmpty) {
                    return Text(
                      '${subCategories.length} subcategories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    );
                  }

                  final products = ref.watch(productsByCategoryProvider(widget.category.id));
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
