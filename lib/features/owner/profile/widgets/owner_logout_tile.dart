import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/widgets/glass_container.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_controller.dart';
import 'package:smartware/widgets/app_dialog.dart';



class OwnerLogoutTile extends StatelessWidget {
  const OwnerLogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final controller = Get.find<OwnerProfileController>();
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
  final confirmed = await AppDialogs.showConfirmDialog(
    title: "Logout".tr,
    message: "Are you sure you want to logout?".tr,
    confirmText: "Logout".tr,
    cancelText: "Cancel".tr,
    confirmColor: cs.error,
  );

  if (confirmed == true) {
    controller.logout();
  }
},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: cs.error,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    "Sign Out".tr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: cs.error.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}