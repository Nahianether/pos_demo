import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/cart_item_hive.dart';
import '../models/settings_hive.dart';

class ThermalPrinterService {
  static final ThermalPrinterService _instance = ThermalPrinterService._internal();
  factory ThermalPrinterService() => _instance;
  ThermalPrinterService._internal();

  /// Print receipt for a completed order
  /// If no printer is detected or printing fails, automatically generates PDF
  Future<bool> printReceipt({
    required List<CartItemHive> items,
    required double subtotal,
    required SettingsHive settings,
    String? customerName,
    bool isFriendBill = false,
    String paymentMethod = 'Cash',
    double manualDiscount = 0.0,
  }) async {
    try {
      final pdf = await _generateReceipt(
        items: items,
        subtotal: subtotal,
        settings: settings,
        customerName: customerName,
        isFriendBill: isFriendBill,
        paymentMethod: paymentMethod,
        manualDiscount: manualDiscount,
      );

      // Try to print the receipt
      final result = await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      return result;
    } catch (e) {
      // If printing fails, automatically share as PDF
      try {
        await shareReceipt(
          items: items,
          subtotal: subtotal,
          settings: settings,
          customerName: customerName,
          isFriendBill: isFriendBill,
          paymentMethod: paymentMethod,
          manualDiscount: manualDiscount,
        );
        return true;
      } catch (pdfError) {
        throw Exception('Failed to print or generate PDF: $pdfError');
      }
    }
  }

  /// Print receipt or generate PDF with user choice
  /// Returns true if printed, false if PDF was generated
  Future<bool> printOrGeneratePdf({
    required List<CartItemHive> items,
    required double subtotal,
    required SettingsHive settings,
    String? customerName,
    bool isFriendBill = false,
    String paymentMethod = 'Cash',
    bool forcePdf = false,
    double manualDiscount = 0.0,
  }) async {
    final pdf = await _generateReceipt(
      items: items,
      subtotal: subtotal,
      settings: settings,
      customerName: customerName,
      isFriendBill: isFriendBill,
      paymentMethod: paymentMethod,
      manualDiscount: manualDiscount,
    );

    if (forcePdf) {
      // Generate PDF directly without trying to print
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      return false;
    } else {
      // Try to print first
      try {
        final result = await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
        return result;
      } catch (e) {
        // If printing fails, share as PDF
        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
        return false;
      }
    }
  }

  /// Share receipt as PDF
  Future<void> shareReceipt({
    required List<CartItemHive> items,
    required double subtotal,
    required SettingsHive settings,
    String? customerName,
    bool isFriendBill = false,
    String paymentMethod = 'Cash',
    double manualDiscount = 0.0,
  }) async {
    try {
      final pdf = await _generateReceipt(
        items: items,
        subtotal: subtotal,
        settings: settings,
        customerName: customerName,
        isFriendBill: isFriendBill,
        paymentMethod: paymentMethod,
        manualDiscount: manualDiscount,
      );

      // Share the receipt
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      throw Exception('Failed to share receipt: $e');
    }
  }

  /// Generate thermal receipt PDF
  Future<pw.Document> _generateReceipt({
    required List<CartItemHive> items,
    required double subtotal,
    required SettingsHive settings,
    String? customerName,
    bool isFriendBill = false,
    String paymentMethod = 'Cash',
    double manualDiscount = 0.0,
  }) async {
    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    final orderId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);

    final vat = settings.calculateVat(subtotal);
    final discount = settings.calculateDiscount(subtotal);
    double total = settings.calculateTotal(subtotal) - manualDiscount;

    if (isFriendBill) {
      total = total.roundToDouble();
    }

    // Use thermal receipt size (80mm width, variable height)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text(
                'POS SYSTEM',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Receipt',
                style: const pw.TextStyle(
                  fontSize: 16,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 8),

              // Order Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Order #$orderId'),
                  pw.Text(dateFormat.format(DateTime.now())),
                ],
              ),
              if (customerName != null && customerName.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Customer:'),
                    pw.Text(customerName),
                  ],
                ),
              ],
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payment:'),
                  pw.Text(paymentMethod),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.SizedBox(height: 8),

              // Items Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'Item',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Qty',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Price',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Total',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(),
              pw.SizedBox(height: 4),

              // Items List
              ...items.map((item) => pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          item.product.name,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          '${item.quantity}',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          currencyFormat.format(item.product.price),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          currencyFormat.format(item.totalPrice),
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                ],
              )),

              pw.Divider(),
              pw.SizedBox(height: 8),

              // Subtotal
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:'),
                  pw.Text(currencyFormat.format(subtotal)),
                ],
              ),

              // VAT
              if (vat > 0) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('VAT (${settings.vatPercentage.toStringAsFixed(1)}%):'),
                    pw.Text(currencyFormat.format(vat)),
                  ],
                ),
              ],

              // Discount
              if (discount > 0) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      settings.isDiscountPercentage
                          ? 'Discount (${settings.discountPercentage.toStringAsFixed(1)}%):'
                          : 'Discount:',
                    ),
                    pw.Text('- ${currencyFormat.format(discount)}'),
                  ],
                ),
              ],

              // Manual/Additional Discount
              if (manualDiscount > 0) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Additional Discount:'),
                    pw.Text('- ${currencyFormat.format(manualDiscount)}'),
                  ],
                ),
              ],

              // Friend Bill Round Off
              if (isFriendBill) ...[
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Round Off:'),
                    pw.Text(
                      currencyFormat.format(total - (settings.calculateTotal(subtotal) - manualDiscount)),
                    ),
                  ],
                ),
              ],

              pw.SizedBox(height: 8),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 8),

              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    currencyFormat.format(total),
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.SizedBox(height: 8),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Please visit again',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.SizedBox(height: 16),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
