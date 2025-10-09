import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pos_provider.dart';
import 'checkout_dialog.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildCartItems()),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart, color: Color(0xFF3498DB)),
          const SizedBox(width: 12),
          const Text(
            'Current Order',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const Spacer(),
          Consumer<POSProvider>(
            builder: (context, provider, _) {
              if (provider.cartItems.isEmpty) return const SizedBox.shrink();
              return InkWell(
                onTap: () => provider.clearCart(),
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        if (provider.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Cart is empty',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add items to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.cartItems.length,
          itemBuilder: (context, index) {
            return _CartItemTile(cartItem: provider.cartItems[index]);
          },
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[200]!),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSummaryRow('Items', '${provider.cartItemsCount}'),
              const SizedBox(height: 8),
              _buildSummaryRow('Subtotal', currencyFormat.format(provider.cartTotal)),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    currencyFormat.format(provider.cartTotal),
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
                  onPressed: provider.cartItems.isEmpty
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
      },
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CheckoutDialog(),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(cartItem.product.price),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  context.read<POSProvider>().removeFromCart(cartItem.product.id);
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    _buildQuantityButton(
                      context,
                      Icons.remove,
                      () {
                        context.read<POSProvider>().updateCartItemQuantity(
                              cartItem.product.id,
                              cartItem.quantity - 1,
                            );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      context,
                      Icons.add,
                      () {
                        context.read<POSProvider>().updateCartItemQuantity(
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

  Widget _buildQuantityButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: const Color(0xFF3498DB)),
      ),
    );
  }
}
