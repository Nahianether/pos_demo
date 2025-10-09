import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_message.dart';

// Notification Provider
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationMessage?>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<NotificationMessage?> {
  NotificationNotifier() : super(null);

  void showNotification(NotificationMessage notification) {
    state = notification;

    // Auto-hide after duration
    Future.delayed(notification.duration, () {
      if (state == notification) {
        state = null;
      }
    });
  }

  void showSuccess(String message, {Duration? duration}) {
    showNotification(NotificationMessage(
      message: message,
      type: NotificationType.success,
      duration: duration ?? const Duration(seconds: 2),
    ));
  }

  void showError(String message, {Duration? duration}) {
    showNotification(NotificationMessage(
      message: message,
      type: NotificationType.error,
      duration: duration ?? const Duration(seconds: 3),
    ));
  }

  void showInfo(String message, {Duration? duration}) {
    showNotification(NotificationMessage(
      message: message,
      type: NotificationType.info,
      duration: duration ?? const Duration(seconds: 2),
    ));
  }

  void showWarning(String message, {Duration? duration}) {
    showNotification(NotificationMessage(
      message: message,
      type: NotificationType.warning,
      duration: duration ?? const Duration(seconds: 3),
    ));
  }

  void hideNotification() {
    state = null;
  }
}