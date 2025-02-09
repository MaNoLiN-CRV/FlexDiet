import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Displays a custom toast message.
///
/// This function creates and displays a toast with a customizable appearance,
/// including an icon, message, background color, and duration. It leverages
/// `FToast` for more control over toast presentation.  Uses theme colors.
///
/// Example 1:
///
/// ```dart
/// ShowToast(context, "Operation successful!", toastType: ToastType.success);
/// ```
/// Example 2:
///
/// ```dart
/// ShowToast(context, "An error occurred.", toastType: ToastType.error);
/// ```
void ShowToast(BuildContext context, String mensaje,
    {ToastType toastType = ToastType.info}) {
  FToast fToast = FToast();
  fToast.init(context);

  Color backgroundColor;
  IconData icon;

  final theme = Theme.of(context);

  switch (toastType) {
    case ToastType.success:
      backgroundColor = theme.colorScheme.success;
      icon = Icons.check;
      break;
    case ToastType.error:
      backgroundColor = theme.colorScheme.error;
      icon = Icons.error;
      break;
    case ToastType.warning:
      backgroundColor = theme.colorScheme.warning;
      icon = Icons.warning;
      break;
    case ToastType.info:
      backgroundColor = theme.colorScheme.primary;
      icon = Icons.info;
      break;
  }

  fToast.showToast(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary, size: 20),
          const SizedBox(width: 8),
          Text(
            mensaje,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
    ),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
    positionedToastBuilder: (context, child, gravity) => Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: child,
    ),
  );
}

extension CustomColorScheme on ColorScheme {
  Color get success => const Color(0xFF4CAF50);
  Color get warning => const Color(0xFFFF9800);
}
