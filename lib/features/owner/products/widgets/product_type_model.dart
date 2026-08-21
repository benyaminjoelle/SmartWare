import 'package:flutter/material.dart';

class ProductTypeModel {
  /// Owner preference key.
  /// Example: canned_foods, fresh_foods, baby_care
  final String id;

  /// Database ID used by /api/products.
  /// Example: 1, 2, 27
  final int categoryId;

  /// Display name.
  final String title;

  /// Same category key/name.
  final String key;

  final IconData icon;

  const ProductTypeModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.key,
    required this.icon,
  });
}