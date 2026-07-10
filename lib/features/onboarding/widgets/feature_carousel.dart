import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/onboarding/controller/onboarding_carousel_controller.dart';

class FeatureCarousel extends StatelessWidget {
  FeatureCarousel({super.key});

  final OnboardingCarouselController controller =
      Get.find<OnboardingCarouselController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    final height = (size.height * 0.24).clamp(180.0, 240.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.features.length,
            itemBuilder: (context, index) {
              final item = controller.features[index];
              return _FeatureCard(item: item);
            },
          ),
        ),

        const SizedBox(height: 14),

        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.features.length, (index) {
              final active = controller.currentPage.value == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? colors.primary : colors.onSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 40, color: colors.primary),
                const SizedBox(height: 12),
                Text(
                  item.title.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
