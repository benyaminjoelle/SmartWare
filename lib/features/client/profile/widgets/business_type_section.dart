import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/widgets/business_type_model.dart';

class BusinessTypeSection extends StatelessWidget {
  const BusinessTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final selectedBusinessType = controller.selectedBusinessType.value;
      final hasSelection = selectedBusinessType.isNotEmpty;

      return LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 800;

          final headerBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Business Type",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Select the business type that aligns with your work.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],
          );

          final listBlock = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.businessTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = controller.businessTypes[index];
                  final selected = selectedBusinessType == item.id;

                  return _ElegantTypeTile(
                    item: item,
                    selected: selected,
                    onTap: () => controller.selectBusinessType(item.id),
                  );
                },
              ),
              
              // Dynamic clear button appearing with a quick layout shift when a choice is active
              if (hasSelection)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: controller.clearBusinessType,
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 16,
                        color: cs.error,
                      ),
                      label: Text(
                        "Clear Selection",
                        style: TextStyle(
                          color: cs.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );

          if (isLargeScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: headerBlock),
                const SizedBox(width: 64),
                Expanded(flex: 5, child: listBlock),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBlock,
              const SizedBox(height: 32),
              listBlock,
            ],
          );
        },
      );
    });
  }
}

class _ElegantTypeTile extends StatelessWidget {
  final BusinessTypeModel item;
  final bool selected;
  final VoidCallback onTap;

  const _ElegantTypeTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? cs.primary : Colors.transparent,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 24,
                color: selected ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? cs.primary : cs.onSurface,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.65),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}