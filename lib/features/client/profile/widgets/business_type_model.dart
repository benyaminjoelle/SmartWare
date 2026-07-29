import 'package:flutter/material.dart';

class BusinessTypeModel {
  final String id; // backend value
  final String title;
  final String subtitle;
  final IconData icon;

  const BusinessTypeModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}