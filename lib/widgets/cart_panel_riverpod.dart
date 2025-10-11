import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/pos_riverpod_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/cart_item_hive.dart';
import 'checkout_dialog_riverpod.dart';

class CartPanelRiverpod extends ConsumerWidget {
  const CartPanelRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildHeader(ref),
        Expanded(
          child: _buildCartItems(ref),
        ),
        _buildFooter(context, ref),
      ],
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.getBorderColor(isDark)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart, color: Color(0xFF3498DB)),
          const SizedBox(width: 12),
          Text(
            'Current Order',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextColor(isDark),
            ),
          ),
          const Spacer(),
          if (cartItems.isNotEmpty)
            InkWell(
              onTap: () => ref.read(cartProvider.notifier).clearCart(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: Colors.red[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItems(WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    if (cartItems.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'Cart is empty',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add items to get started',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return _CartItemTile(cartItem: cartItems[index]);
      },
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final vat = ref.watch(cartVatProvider);
    final discount = ref.watch(cartDiscountProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final cartItemsCount = ref.watch(cartItemsCountProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(isDark),
        border: Border(
          top: BorderSide(color: AppTheme.getBorderColor(isDark)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Items', '$cartItemsCount'),
          const SizedBox(height: 8),
          _buildSummaryRow('Subtotal', currencyFormat.format(subtotal)),

          // Show VAT if greater than 0
          if (vat > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'VAT (${settings.vatPercentage.toStringAsFixed(1)}%)',
              currencyFormat.format(vat),
            ),
          ],

          // Show Discount if greater than 0
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              settings.isDiscountPercentage
                  ? 'Discount (${settings.discountPercentage.toStringAsFixed(1)}%)'
                  : 'Discount',
              '- ${currencyFormat.format(discount)}',
              valueColor: const Color(0xFFE74C3C),
            ),
          ],

          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextColor(isDark),
                ),
              ),
              Text(
                currencyFormat.format(cartTotal),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () => _showCheckoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3498DB),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Consumer(
      builder: (context, ref, _) {
        final isDark = ref.watch(isDarkModeProvider);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.getSecondaryTextColor(isDark),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.getTextColor(isDark),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CheckoutDialogRiverpod(),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItemHive cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isDark = ref.watch(isDarkModeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariantColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorderColor(isDark)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getTextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(cartItem.product.price),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.getSecondaryTextColor(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  ref.read(cartProvider.notifier).removeFromCart(cartItem.product.id);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceColor(isDark),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.getBorderColor(isDark)),
                ),
                child: Row(
                  children: [
                    _buildQuantityButton(
                      context,
                      ref,
                      Icons.remove,
                      () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              cartItem.product.id,
                              cartItem.quantity - 1,
                            );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${cartItem.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.getTextColor(isDark),
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      context,
                      ref,
                      Icons.add,
                      () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              cartItem.product.id,
                              cartItem.quantity + 1,
                            );
                      },
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(cartItem.totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: const Color(0xFF3498DB)),
      ),
    );
  }
}
