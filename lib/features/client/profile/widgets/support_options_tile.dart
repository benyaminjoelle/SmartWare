import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportOptionsTile {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: cs.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                Icon(
                  Icons.support_agent_rounded,
                  size: 42,
                  color: cs.primary,
                ),

                const SizedBox(height: 12),

                Text(
                  "Contact Support".tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Choose your preferred way to reach us.".tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),

                const SizedBox(height: 24),

                _option(
                  context,
                  icon: Icons.email_rounded,
                  title: "Email".tr,
                  subtitle: "Send us an email".tr,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Email
                  },
                ),

                const SizedBox(height: 12),

                _option(
                  context,
                  icon: Icons.chat_rounded,
                  title: "WhatsApp".tr,
                  subtitle: "Chat with our team".tr,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: WhatsApp
                  },
                ),

                const SizedBox(height: 12),

                _option(
                  context,
                  icon: Icons.language_rounded,
                  title: "Website".tr,
                  subtitle: "Visit our official website".tr,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Website
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: cs.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}