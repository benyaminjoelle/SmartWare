import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:storex/features/client/profile/views/client_profile_completion.dart';


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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: isComplete
                ? []
                : [
                    // Primary deep drop shadow pushed downwards
                    BoxShadow(
                      color: ( cs.onSurface).withValues(
                        alpha: 0.18 + (0.07 * glow),
                      ),
                      offset: Offset(0, 14 + (8 * glow)),
                      blurRadius: 20 + (10 * glow),
                      spreadRadius: 1,
                    ),
                    // Ambient colorful tint underlay
                    BoxShadow(
                      color: cs.primary.withValues(
                        alpha: 0.12 + (0.06 * glow),
                      ),
                      offset: Offset(0, 22 + (12 * glow)),
                      blurRadius: 35 + (15 * glow),
                      spreadRadius: -2,
                    ),
                  ],
          ),
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
                                "Profile Completion",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isComplete
                                    ? "Your profile is fully completed"
                                    : "Unlock premium features",
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
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  key: ValueKey("done"),
                                  color: Colors.green,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  key: const ValueKey("arrow"),
                                  size: 15,
                                  color: cs.secondary,
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
                              width: constraints.maxWidth *
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
      );
    });
  }
}