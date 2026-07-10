import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/steps/client_documentations.dart';
import 'package:smartware/features/client/profile/steps/client_location.dart';
import 'package:smartware/features/client/profile/steps/client_prefrences.dart';
import 'package:smartware/widgets/progressbar.dart';

import '../controllers/client_profile_completion_controller.dart';
import '../widgets/glass_container.dart';

class ClientProfileCompletionView extends StatelessWidget {
  const ClientProfileCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClientProfileCompletionController());

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =========================================================
                /// HEADER
                /// =========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Complete Profile",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${controller.profileCompletion.value}%",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// =========================================================
                /// GLOBAL PROGRESS BAR
                /// =========================================================
                AppStepProgressBar(
                  currentStep: controller.currentStep.value,
                  totalSteps: controller.totalSteps,
                ),

                const SizedBox(height: 20),

                /// =========================================================
                /// STEP CONTENT (GLASS CONTAINER)
                /// =========================================================
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: _buildStep(controller),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// =========================================================
  /// STEP ROUTER
  /// =========================================================
  Widget _buildStep(ClientProfileCompletionController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return const PreferencesStep();
      case 1:
        return const ClientLocation();
      case 2:
        return const ClientDocumentations();
      default:
        return const SizedBox();
    }
  }
}
