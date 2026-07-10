import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'action_tile.dart';
import 'glass_container.dart';

class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 10),
            child: Text(
              "ACCOUNT MANAGEMENT".tr,
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),

        GlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              ActionTile(
                icon: Icons.person_outline_rounded,
                title: "Edit Profile".tr,
                onTap: () {
                  Get.toNamed(AppRoutes.clientEditPofile);
                },
              ),

              ActionTile(
                icon: Icons.notifications_none_rounded,
                title: "Notifications".tr,
                onTap: () {},
              ),
              ActionTile(
                icon: Icons.tune_rounded,
                title: "Settings".tr,
                isLast: true,
                onTap: () {
                  Get.toNamed(AppRoutes.clientSettings);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
