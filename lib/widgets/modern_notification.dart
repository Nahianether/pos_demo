import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_message.dart';
import '../providers/notification_provider.dart';

class ModernNotificationOverlay extends ConsumerWidget {
  final Widget child;

  const ModernNotificationOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationProvider);

    return Stack(
      children: [
        child,
        if (notification != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: ModernNotificationCard(
              notification: notification,
              onDismiss: () => ref.read(notificationProvider.notifier).hideNotification(),
            ),
          ),
      ],
    );
  }
}

class ModernNotificationCard extends StatelessWidget {
  final NotificationMessage notification;
  final VoidCallback onDismiss;

  const ModernNotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                notification.defaultIcon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for showing notifications easily
class NotificationHelpers {
  static void showAddedToCart(WidgetRef ref, String productName) {
    ref.read(notificationProvider.notifier).showSuccess(
      '$productName added to cart',
    );
  }

  static void showRemovedFromCart(WidgetRef ref, String productName) {
    ref.read(notificationProvider.notifier).showInfo(
      '$productName removed from cart',
    );
  }

  static void showQuantityUpdated(WidgetRef ref, String productName, int quantity) {
    ref.read(notificationProvider.notifier).showInfo(
      '$productName quantity updated to $quantity',
    );
  }

  static void showCartCleared(WidgetRef ref) {
    ref.read(notificationProvider.notifier).showInfo(
      'Cart cleared',
    );
  }

  static void showCheckoutSuccess(WidgetRef ref) {
    ref.read(notificationProvider.notifier).showSuccess(
      'Checkout completed successfully',
    );
  }

  static void showInfo(WidgetRef ref, String message) {
    ref.read(notificationProvider.notifier).showInfo(message);
  }

  static void showSuccess(WidgetRef ref, String message) {
    ref.read(notificationProvider.notifier).showSuccess(message);
  }

  static void showError(WidgetRef ref, String message) {
    ref.read(notificationProvider.notifier).showError(message);
  }
}