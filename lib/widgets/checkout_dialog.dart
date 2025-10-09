import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pos_provider.dart';
import '../models/order.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: Color(0xFF3498DB), size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildCustomerNameField(),
            const SizedBox(height: 16),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 16),
            _buildDiscountField(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildCompleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerNameField() {
    return TextField(
      controller: _customerNameController,
      decoration: InputDecoration(
        labelText: 'Customer Name (Optional)',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPaymentOption(PaymentMethod.cash, Icons.money, 'Cash'),
            const SizedBox(width: 12),
            _buildPaymentOption(PaymentMethod.card, Icons.credit_card, 'Card'),
            const SizedBox(width: 12),
            _buildPaymentOption(PaymentMethod.digital, Icons.phone_android, 'Digital'),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(PaymentMethod method, IconData icon, String label) {
    final isSelected = _selectedPaymentMethod == method;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPaymentMethod = method),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3498DB) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF3498DB) : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF95A5A6),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountField() {
    return TextField(
      controller: _discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount Amount',
        prefixIcon: const Icon(Icons.discount_outlined),
        prefixText: '\$ ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
        final discount = double.tryParse(_discountController.text) ?? 0.0;
        final total = provider.cartTotal - discount;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Subtotal', currencyFormat.format(provider.cartTotal)),
              const SizedBox(height: 8),
              _buildSummaryRow('Discount', '- ${currencyFormat.format(discount)}'),
              const Divider(height: 16),
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
                    currencyFormat.format(total),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                ],
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
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF7F8C8D),
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

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _completeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF27AE60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Complete Order',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _completeOrder() {
    final provider = context.read<POSProvider>();
    final discount = double.tryParse(_discountController.text) ?? 0.0;

    final order = provider.processOrder(
      paymentMethod: _selectedPaymentMethod,
      customerName: _customerNameController.text.isEmpty
          ? null
          : _customerNameController.text,
      discount: discount,
    );

    if (order != null) {
      Navigator.pop(context);
      _showSuccessDialog(order);
    }
  }

  void _showSuccessDialog(Order order) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF27AE60),
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Completed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #${order.id}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      currencyFormat.format(order.grandTotal),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.items.length} items',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
