import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color? confirmColor,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
      
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: confirmColor ?? Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}