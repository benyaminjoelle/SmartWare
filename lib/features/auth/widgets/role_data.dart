import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AccountType { client, warehouseOwner, warehouseStaff }

class RoleModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AccountType type;

  const RoleModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
  });
}

/// Centralized role data
List<RoleModel> getRoles(ColorScheme colors) {
  return [
    RoleModel(
      title: "Client".tr,
      description: "Order products from warehouses".tr,
      icon: Icons.shopping_bag_outlined,
      color: colors.primary,
      type: AccountType.client,
    ),

    RoleModel(
      title: "Warehouse Staff".tr,
      description: "Assist with warehouse operations and inventory management".tr,
      icon: Icons.person_outline,
      color: colors.secondary,
      type: AccountType.warehouseStaff,
    ),
    RoleModel(
      title: "Warehouse Owner".tr,
      description:
          "Manage warehouses, storage, and incoming orders".tr,
      icon: Icons.warehouse_outlined,
      color: colors.tertiary,
      type: AccountType.warehouseOwner,
    ),
  ];
}
