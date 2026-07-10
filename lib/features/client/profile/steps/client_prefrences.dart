import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/client/profile/controllers/client_profile_completion_controller.dart';

class PreferencesStep extends StatelessWidget {
  const PreferencesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<ClientProfileCompletionController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final options = const [
      ("Retail", Icons.store),
      ("Restaurant", Icons.restaurant),
      ("Services", Icons.handyman),
      ("Digital", Icons.computer),
      ("Wholesale", Icons.local_shipping),
    ];

    return Obx(() {
      return Column(
        key: const ValueKey("preferences"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================================================
          /// HEADER TEXT
          /// =========================================================
          Text(
            "What describes your business?",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Choose the category that best fits your business",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),

          const SizedBox(height: 24),

          /// =========================================================
          /// BUSINESS TYPE CARDS
          /// =========================================================
          Expanded(
            child: GridView.builder(
              itemCount: options.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final item = options[index];
                final label = item.$1;
                final icon = item.$2;

                final isSelected =
                    controller.businessCategory.value == label;

                return GestureDetector(
                  onTap: () {
                    controller.businessCategory.value = label;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: isSelected
                          ? cs.primary.withValues(alpha: 0.12)
                          : cs.surface,

                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outline.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),

                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.25),
                                blurRadius: 25,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 34,
                          color: isSelected
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? cs.primary
                                : cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// =========================================================
          /// CONTINUE BUTTON
          /// =========================================================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.businessCategory.value.isEmpty
                  ? null
                  : controller.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      );
    });
  }
}