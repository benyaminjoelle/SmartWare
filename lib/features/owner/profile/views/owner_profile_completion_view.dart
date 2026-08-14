import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/widgets/glass_container.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';
import 'package:smartware/features/owner/profile/steps/owner_documentation.dart';
import 'package:smartware/features/owner/profile/steps/owner_facility_info.dart';
import 'package:smartware/features/owner/profile/steps/owner_location.dart';
import 'package:smartware/features/owner/profile/steps/owner_preferences.dart';
import 'package:smartware/widgets/progressbar.dart';



class OwnerProfileCompletionView extends StatelessWidget {
  const OwnerProfileCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OwnerProfileComplitionController());

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
                   BackButton(onPressed: controller.handleBack,),
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
  Widget _buildStep(OwnerProfileComplitionController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return const OwnerPreferences(); 
        case 1:
        return const OwnerFacilityInfo();
      case 2:
      return const OwnerDocumentation();
      
      case 3:
          return const OwnerLocation();
      default:
        return const SizedBox();
    }
  }
}
