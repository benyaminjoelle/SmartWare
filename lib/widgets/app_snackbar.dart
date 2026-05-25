import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = Get.context;
    final cs = context != null ? Theme.of(context).colorScheme : null;

    Get.snackbar(
      title,
      message,

      snackPosition: position,
      duration: duration,
      isDismissible: true,

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,

      // 🎯 PURE THEME USAGE ONLY
      backgroundColor: cs?.surface,
      colorText: cs?.onSurface,

      icon: icon != null
          ? Icon(
              icon,
              color: iconColor ?? cs?.primary,
            )
          : null,

      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],

      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}