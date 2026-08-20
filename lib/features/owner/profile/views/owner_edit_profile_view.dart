import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/widgets/edit_profile_container.dart';
import 'package:smartware/features/owner/profile/controllers/owner_edit_profile_controller.dart';

class OwnerEditProfileView extends StatelessWidget {
  const OwnerEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;

    final controller = Get.find<OwnerEditProfileController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: media.size.width * 0.05,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 520 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      const BackButton(),
                      const SizedBox(width: 8),
                      Text(
                        "Edit Profile".tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  ProfileSectionCard(
                    icon: Icons.email,
                    iconColor: cs.primary,
                    title: "Change Email".tr,
                    subtitle: "Change your old Email".tr,
                    onTap: controller.goToEmail,
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    icon: Icons.phone,
                    iconColor: cs.primary,
                    title: "Change Phone Number".tr,
                    subtitle: "Change your old phone number".tr,
                    onTap: controller.goToPhone,
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    icon: Icons.password,
                    iconColor: cs.primary,
                    title: "Change Password".tr,
                    subtitle: "Change your old password".tr,
                    onTap: controller.goToPassword,
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    icon: Icons.shield_outlined,
                    iconColor: cs.primary,
                    title: "Change Business Name".tr,
                    subtitle: "Change your old Business name".tr,
                    onTap: controller.goToBusiness,
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    icon: Icons.tune_rounded,
                    iconColor: cs.primary,
                    title: "Edit Preferences".tr,
                    subtitle:
                        "Edit your preferences to get more access".tr,
                    onTap: controller.goToPreferences,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}