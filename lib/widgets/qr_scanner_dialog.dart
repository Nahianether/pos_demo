import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/pos_riverpod_provider.dart';
import '../widgets/modern_notification.dart';

class QRScannerDialog extends ConsumerStatefulWidget {
  const QRScannerDialog({super.key});

  @override
  ConsumerState<QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends ConsumerState<QRScannerDialog> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    // Search for product by ID
    final products = ref.read(productsProvider);
    final product = products.where((p) => p.id == code).firstOrNull;

    if (product != null) {
      // Add product to cart
      await ref.read(cartProvider.notifier).addToCart(product);

      if (mounted) {
        NotificationHelpers.showSuccess(
          ref,
          '${product.name} added to cart',
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        NotificationHelpers.showError(
          ref,
          'Product not found: $code',
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.qr_code_scanner, color: Color(0xFF3498DB), size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Scan Product QR Code',
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

            // Scanner Area
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                    ),

                    // Overlay with scanning frame
                    CustomPaint(
                      painter: ScannerOverlayPainter(),
                      child: Container(),
                    ),

                    // Processing indicator
                    if (_isProcessing)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF3498DB)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Position the QR code within the frame to scan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _controller.toggleTorch(),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Toggle Flash'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF3498DB)),
                      foregroundColor: const Color(0xFF3498DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _controller.switchCamera(),
                    icon: const Icon(Icons.flip_camera_ios),
                    label: const Text('Switch Camera'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF3498DB)),
                      foregroundColor: const Color(0xFF3498DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final framePaint = Paint()
      ..color = const Color(0xFF3498DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Frame dimensions
    final frameSize = size.width * 0.7;
    final left = (size.width - frameSize) / 2;
    final top = (size.height - frameSize) / 2;
    final frameRect = Rect.fromLTWH(left, top, frameSize, frameSize);

    // Draw semi-transparent overlay with cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Draw frame corners
    final cornerLength = 30.0;
    final cornerRadius = 16.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerRadius),
      Offset(left, top + cornerLength),
      framePaint,
    );
    canvas.drawLine(
      Offset(left + cornerRadius, top),
      Offset(left + cornerLength, top),
      framePaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + frameSize, top + cornerRadius),
      Offset(left + frameSize, top + cornerLength),
      framePaint,
    );
    canvas.drawLine(
      Offset(left + frameSize - cornerRadius, top),
      Offset(left + frameSize - cornerLength, top),
      framePaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + frameSize - cornerRadius),
      Offset(left, top + frameSize - cornerLength),
      framePaint,
    );
    canvas.drawLine(
      Offset(left + cornerRadius, top + frameSize),
      Offset(left + cornerLength, top + frameSize),
      framePaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + frameSize, top + frameSize - cornerRadius),
      Offset(left + frameSize, top + frameSize - cornerLength),
      framePaint,
    );
    canvas.drawLine(
      Offset(left + frameSize - cornerRadius, top + frameSize),
      Offset(left + frameSize - cornerLength, top + frameSize),
      framePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
