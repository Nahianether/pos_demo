import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  info,
  warning,
}

class NotificationMessage {
  final String message;
  final NotificationType type;
  final Duration duration;
  final IconData? icon;

  NotificationMessage({
    required this.message,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 2),
    this.icon,
  });

  Color get backgroundColor {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF27AE60);
      case NotificationType.error:
        return const Color(0xFFE74C3C);
      case NotificationType.info:
        return const Color(0xFF3498DB);
      case NotificationType.warning:
        return const Color(0xFFF39C12);
    }
  }

  IconData get defaultIcon {
    if (icon != null) return icon!;

    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
    }
  }
}
