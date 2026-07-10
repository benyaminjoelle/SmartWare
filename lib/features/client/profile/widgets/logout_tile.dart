import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'glass_container.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius:
              BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.error
                        .withValues(alpha: 0.08),
                    borderRadius:
                        BorderRadius.circular(12),
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
                    style: theme
                        .textTheme.bodyMedium
                        ?.copyWith(
                      color: cs.error,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: cs.error
                      .withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}