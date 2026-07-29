import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/constants/app_colors.dart';

class AppDialogs {
  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color? confirmColor,
    Color? cancelColor,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
      
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText.tr,  style: TextStyle(
                color: cancelColor ?? AppColors.primary,
                fontWeight: FontWeight.w600,
              ),),
          ),
          
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText.tr,
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