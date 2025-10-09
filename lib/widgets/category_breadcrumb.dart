import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';

class CategoryBreadcrumb extends StatelessWidget {
  const CategoryBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        if (provider.categoryPath.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => provider.resetNavigation(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.home, size: 18, color: Color(0xFF3498DB)),
                      const SizedBox(width: 6),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...provider.categoryPath.asMap().entries.map((entry) {
                final index = entry.key;
                final categoryId = entry.value;
                final category = provider.getCategoryById(categoryId);
                final isLast = index == provider.categoryPath.length - 1;

                return Row(
                  children: [
                    Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
                    InkWell(
                      onTap: isLast ? null : () => provider.selectCategory(categoryId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: isLast
                            ? BoxDecoration(
                                color: const Color(0xFF3498DB),
                                borderRadius: BorderRadius.circular(6),
                              )
                            : null,
                        child: Text(
                          category?.name ?? '',
                          style: TextStyle(
                            color: isLast ? Colors.white : Colors.grey[700],
                            fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (provider.categoryPath.isNotEmpty) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => provider.navigateBack(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF95A5A6)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
