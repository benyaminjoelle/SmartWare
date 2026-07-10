import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/views/client_profile_completion_view.dart';

import '../controllers/profile_card_animation_controller.dart';
import 'glass_container.dart';

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject/Find the required controllers
    final animController = Get.put(ProfileCardAnimationController());
    final profileController = Get.put(ClientProfileCompletionController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final isComplete = profileController.isProfileComplete;
      final glow = animController.glowValue.value;
      final scale = animController.scaleValue.value;

      return Transform.scale(
        scale: isComplete ? 1.0 : scale,
        child: Container(
          // Using standard Container decoration to firmly anchor the sub-layers
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: isComplete
                ? []
                : [
                    // Deep drop shadow distinctly pushed downwards on the Y-axis
                    // BoxShadow(
                    //   color: cs.onSurface.withValues(
                    //     alpha: 0.14 + (0.05 * glow),
                    //   ),
                    //   // Clamped lower offset to prevent shadow bleeding upwards
                    //   offset: Offset(0, 16 + (6 * glow)),
                    //   blurRadius: 24 + (8 * glow),
                    //   spreadRadius: 0,
                    // ),
                    // Ambient color blooming glow strictly forced beneath
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.10 + (0.04 * glow)),
                      offset: Offset(0, 24 + (10 * glow)),
                      blurRadius: 32 + (12 * glow),
                      spreadRadius:
                          -4, // Tightened spread radius to prevent upward bleed
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  if (!isComplete) {
                    Get.to(() => const ClientProfileCompletionView());
                  }
                },
                child: GlassContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Profile Completion".tr,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isComplete
                                      ? "Your profile is fully completed".tr
                                      : "Unlock premium features".tr,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${profileController.profileCompletion.value}%",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isComplete
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    key: ValueKey('done'),
                                    color: cs.tertiary,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    key: const ValueKey("arrow"),
                                    size: 15,
                                    color: cs.primary,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: cs.onSurface.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeInOutCubic,
                                width:
                                    constraints.maxWidth *
                                    profileController.completionPercent,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cs.primary,
                                      cs.secondary,
                                      cs.tertiary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
