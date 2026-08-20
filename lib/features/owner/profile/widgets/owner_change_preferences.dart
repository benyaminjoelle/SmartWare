import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/profile/widgets/owner_product_type_section.dart';
import 'package:smartware/features/owner/profile/controllers/owner_edit_profile_controller.dart';

import 'package:smartware/widgets/primary_button.dart';

class OwnerChangePreferences extends StatelessWidget {
  const OwnerChangePreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller =
        Get.find<OwnerEditProfileController>();

    // ============================================================
    // LOAD ONLY ONCE AFTER THE WIDGET IS INSERTED
    // ============================================================

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasPreferences.value &&
          !controller.isPreferencesLoading.value) {
        controller.loadEditPreferences();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const BackButton(),

            Expanded(
              child: Obx(() {
                // ==================================================
                // LOADING
                // ==================================================

                if (controller
                    .isPreferencesLoading.value) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                // ==================================================
                // NO PREFERENCES
                // ==================================================

                if (!controller
                    .hasPreferences.value) {
                  return const _NoPreferencesState();
                }

                // ==================================================
                // EDIT PREFERENCES
                // ==================================================

                return SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Business Preferences".tr,
                        style: theme
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // SAME EXISTING BUSINESS TYPE UI
                      // ==================================================

                   

                      const SizedBox(height: 36),

                      // ==================================================
                      // SAME EXISTING PRODUCT TYPE UI
                      // ==================================================

                      const OwnerProductTypeSection(),
                    ],
                  ),
                );
              }),
            ),

            // ======================================================
            // SAVE BUTTON
            // ======================================================

            Obx(() {
              if (!controller
                  .hasPreferences.value) {
                return const SizedBox.shrink();
              }

              final isValid =
                  controller
                          .editBusinessType
                          .value
                          .trim()
                          .isNotEmpty &&
                      controller
                          .editBusinessCategories
                          .isNotEmpty;

              return Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  20,
                ),
                child: PrimaryButton(
                  text: controller
                          .isLoading.value
                      ? "Saving...".tr
                      : "Save Preferences".tr,

                  isDisabled:
                      controller
                              .isLoading.value ||
                          !isValid,

                  onPressed:
                      controller
                              .isLoading.value ||
                          !isValid
                      ? null
                      : () {
                          controller
                              .updateBusinessPreferences();
                        },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// NO PREFERENCES STATE
// ================================================================

class _NoPreferencesState
    extends StatelessWidget {
  const _NoPreferencesState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(32),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_outlined,
              size: 56,
              color: cs.outline,
            ),

            const SizedBox(height: 20),

            Text(
              "No Preferences Found".tr,
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Sorry, you don't have business preferences to edit yet."
                  .tr,
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                    cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Go Back".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}