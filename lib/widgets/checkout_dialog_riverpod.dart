import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/pos_riverpod_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/modern_notification.dart';
import '../services/thermal_printer_service.dart';
import '../models/cart_item_hive.dart';
import '../models/settings_hive.dart';

enum PaymentMethod { cash, card, digital }

class CheckoutDialogRiverpod extends ConsumerStatefulWidget {
  const CheckoutDialogRiverpod({super.key});

  @override
  ConsumerState<CheckoutDialogRiverpod> createState() => _CheckoutDialogRiverpodState();
}

class _CheckoutDialogRiverpodState extends ConsumerState<CheckoutDialogRiverpod> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _manualDiscountController = TextEditingController();
  bool _isFriendBill = false;
  bool _enableManualDiscount = false;
  bool _isManualDiscountPercentage = true; // true for %, false for fixed amount

  // Store last order data for re-printing
  List<CartItemHive>? _lastOrderItems;
  double? _lastOrderSubtotal;
  SettingsHive? _lastOrderSettings;
  String? _lastCustomerName;
  bool? _lastIsFriendBill;
  String? _lastPaymentMethod;
  double? _lastManualDiscount;

  @override
  void dispose() {
    _customerNameController.dispose();
    _manualDiscountController.dispose();
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
            _buildFriendBillOption(),
            const SizedBox(height: 16),
            _buildManualDiscountSection(),
            const SizedBox(height: 16),
            _buildPaymentMethodSelector(),
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

  Widget _buildFriendBillOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFriendBill ? const Color(0xFF27AE60) : const Color(0xFFE0E0E0),
          width: _isFriendBill ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isFriendBill ? Icons.favorite : Icons.favorite_border,
            color: _isFriendBill ? const Color(0xFF27AE60) : const Color(0xFF95A5A6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Friend Bill',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isFriendBill ? const Color(0xFF27AE60) : const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isFriendBill
                    ? 'Bill will be rounded down to whole number'
                    : 'Apply friend discount and round down total',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isFriendBill,
            onChanged: (value) => setState(() => _isFriendBill = value),
            activeColor: const Color(0xFF27AE60),
          ),
        ],
      ),
    );
  }

  Widget _buildManualDiscountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _enableManualDiscount ? const Color(0xFFE67E22) : const Color(0xFFE0E0E0),
          width: _enableManualDiscount ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _enableManualDiscount ? Icons.local_offer : Icons.local_offer_outlined,
                color: _enableManualDiscount ? const Color(0xFFE67E22) : const Color(0xFF95A5A6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Discount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _enableManualDiscount ? const Color(0xFFE67E22) : const Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add extra discount on top of default discount',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _enableManualDiscount,
                onChanged: (value) {
                  setState(() {
                    _enableManualDiscount = value;
                    if (!value) {
                      _manualDiscountController.clear();
                    }
                  });
                },
                activeColor: const Color(0xFFE67E22),
              ),
            ],
          ),
          if (_enableManualDiscount) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manualDiscountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _isManualDiscountPercentage ? 'Discount %' : 'Discount Amount',
                      prefixIcon: Icon(
                        _isManualDiscountPercentage ? Icons.percent : Icons.attach_money,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE67E22), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isManualDiscountPercentage = true),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isManualDiscountPercentage
                              ? const Color(0xFFE67E22)
                              : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            '%',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _isManualDiscountPercentage
                                ? Colors.white
                                : const Color(0xFF95A5A6),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: const Color(0xFFE0E0E0),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isManualDiscountPercentage = false),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isManualDiscountPercentage
                              ? const Color(0xFFE67E22)
                              : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            '\$',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: !_isManualDiscountPercentage
                                ? Colors.white
                                : const Color(0xFF95A5A6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  double _calculateManualDiscount(double subtotal) {
    if (!_enableManualDiscount) return 0.0;

    final value = double.tryParse(_manualDiscountController.text) ?? 0.0;
    if (value <= 0) return 0.0;

    if (_isManualDiscountPercentage) {
      return subtotal * (value / 100);
    } else {
      return value;
    }
  }

  Widget _buildOrderSummary() {
    final subtotal = ref.watch(cartSubtotalProvider);
    final vat = ref.watch(cartVatProvider);
    final discount = ref.watch(cartDiscountProvider);
    final settings = ref.watch(settingsProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // Calculate manual discount
    final manualDiscount = _calculateManualDiscount(subtotal);

    // Calculate total with manual discount and friend bill logic
    double total = settings.calculateTotal(subtotal) - manualDiscount;
    if (_isFriendBill) {
      total = total.floorToDouble(); // Always round down for friend bills
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', currencyFormat.format(subtotal)),
          const SizedBox(height: 8),
          if (vat > 0) ...[
            _buildSummaryRow('VAT (${settings.vatPercentage.toStringAsFixed(1)}%)', currencyFormat.format(vat)),
            const SizedBox(height: 8),
          ],
          if (discount > 0) ...[
            _buildSummaryRow(
              settings.isDiscountPercentage
                ? 'Discount (${settings.discountPercentage.toStringAsFixed(1)}%)'
                : 'Discount',
              '- ${currencyFormat.format(discount)}'
            ),
            const SizedBox(height: 8),
          ],
          if (manualDiscount > 0) ...[
            _buildSummaryRow(
              _isManualDiscountPercentage
                ? 'Additional Discount (${_manualDiscountController.text}%)'
                : 'Additional Discount',
              '- ${currencyFormat.format(manualDiscount)}',
              color: const Color(0xFFE67E22),
            ),
            const SizedBox(height: 8),
          ],
          if (_isFriendBill) ...[
            _buildSummaryRow(
              'Round Off Adjustment',
              currencyFormat.format(total - (settings.calculateTotal(subtotal) - manualDiscount)),
              color: const Color(0xFF27AE60),
            ),
            const SizedBox(height: 8),
          ],
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
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
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
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color ?? const Color(0xFF2C3E50),
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

  void _completeOrder() async {
    final subtotal = ref.read(cartSubtotalProvider);
    final cartItems = ref.read(cartProvider);
    final settings = ref.read(settingsProvider);
    final customerName = _customerNameController.text.trim().isNotEmpty
        ? _customerNameController.text.trim()
        : null;

    // Calculate manual discount
    final manualDiscount = _calculateManualDiscount(subtotal);

    // Store order data for re-printing
    _lastOrderItems = List.from(cartItems);
    _lastOrderSubtotal = subtotal;
    _lastOrderSettings = settings;
    _lastCustomerName = customerName;
    _lastIsFriendBill = _isFriendBill;
    _lastPaymentMethod = _selectedPaymentMethod.name.toUpperCase();
    _lastManualDiscount = manualDiscount;

    // Calculate total with manual discount and friend bill logic
    double total = settings.calculateTotal(subtotal) - manualDiscount;
    if (_isFriendBill) {
      total = total.floorToDouble(); // Always round down for friend bills
    }

    // Print receipt
    try {
      await ThermalPrinterService().printReceipt(
        items: cartItems,
        subtotal: subtotal,
        settings: settings,
        customerName: customerName,
        isFriendBill: _isFriendBill,
        paymentMethod: _selectedPaymentMethod.name.toUpperCase(),
        manualDiscount: manualDiscount,
      );
    } catch (e) {
      // If printing fails, show error but still complete the order
      if (mounted) {
        NotificationHelpers.showError(ref, 'Failed to print receipt: $e');
      }
    }

    // Clear the cart
    await ref.read(cartProvider.notifier).clearCart();

    if (!mounted) return;

    Navigator.pop(context);

    // Show success notification instead of dialog
    NotificationHelpers.showCheckoutSuccess(ref);
    _showSuccessDialog(total, cartItems.length);
  }

  void _showSuccessDialog(double total, int itemCount) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();

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
                'Order #$orderId',
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
                      currencyFormat.format(total),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount items',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _reprintReceipt,
                        icon: const Icon(Icons.print, size: 18),
                        label: const Text('Print'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF3498DB),
                          side: const BorderSide(color: Color(0xFF3498DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _generatePdf,
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text('PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE67E22),
                          side: const BorderSide(color: Color(0xFFE67E22)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reprintReceipt() async {
    if (_lastOrderItems == null || _lastOrderSubtotal == null || _lastOrderSettings == null) {
      return;
    }

    try {
      await ThermalPrinterService().printReceipt(
        items: _lastOrderItems!,
        subtotal: _lastOrderSubtotal!,
        settings: _lastOrderSettings!,
        customerName: _lastCustomerName,
        isFriendBill: _lastIsFriendBill ?? false,
        paymentMethod: _lastPaymentMethod ?? 'CASH',
        manualDiscount: _lastManualDiscount ?? 0.0,
      );

      if (mounted) {
        NotificationHelpers.showSuccess(ref, 'Receipt sent to printer');
      }
    } catch (e) {
      if (mounted) {
        NotificationHelpers.showError(ref, 'Printing failed: $e');
      }
    }
  }

  void _generatePdf() async {
    if (_lastOrderItems == null || _lastOrderSubtotal == null || _lastOrderSettings == null) {
      return;
    }

    try {
      await ThermalPrinterService().printOrGeneratePdf(
        items: _lastOrderItems!,
        subtotal: _lastOrderSubtotal!,
        settings: _lastOrderSettings!,
        customerName: _lastCustomerName,
        isFriendBill: _lastIsFriendBill ?? false,
        paymentMethod: _lastPaymentMethod ?? 'CASH',
        forcePdf: true, // Force PDF generation
        manualDiscount: _lastManualDiscount ?? 0.0,
      );

      if (mounted) {
        NotificationHelpers.showSuccess(ref, 'PDF receipt generated');
      }
    } catch (e) {
      if (mounted) {
        NotificationHelpers.showError(ref, 'Failed to generate PDF: $e');
      }
    }
  }
}
