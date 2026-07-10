import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/client/profile/controllers/client_settings_controller.dart';
import 'package:storex/features/client/profile/widgets/about_StoreX.dart';
import 'package:storex/features/client/profile/widgets/action_tile.dart';
import 'package:storex/features/client/profile/widgets/glass_container.dart';
import 'package:storex/features/client/profile/widgets/privacy_policy.dart';
import 'package:storex/features/client/profile/widgets/support_options_tile.dart';
import 'package:storex/localization/local_controller.dart';

class ClientSettings extends StatelessWidget {
  const ClientSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;
    final localeController = Get.put(LocaleController());

    final controller = Get.find<ClientSettingsController>();

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
                        "Settings",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// =========================
                  /// APPEARANCE
                  /// =========================
                  const _SectionTitle("Appearance"),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        Obx(
                          () => ActionTile(
                            onTap: () {},
                            icon: Icons.dark_mode_rounded,
                            title: "Dark Theme",
                            trailing: Switch.adaptive(
                              value: controller.isDarkMode.value,
                              onChanged: (value) {
                                controller.changeTheme(
                                  value ? ThemeMode.dark : ThemeMode.light,
                                );
                              },
                            ),
                          ),
                        ),

                        ActionTile(
                          onTap: () {},
                          icon: Icons.language_rounded,
                          title: "Language",

                          isLast: true,
                          trailing: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.expand_more_rounded,
                              color: cs.onSurfaceVariant,
                            ),
                            onSelected: (value) {
                              localeController.changeLanguage(value);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "en",
                                child: Text("English"),
                              ),
                              PopupMenuItem(value: "ar", child: Text("Arabic")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// =========================
                  /// NOTIFICATIONS
                  /// =========================
                  const _SectionTitle("Notifications"),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        Obx(
                          () => ActionTile(
                            onTap: () {},
                            icon: Icons.notifications_active_rounded,
                            title: "Notifications",
                            subtitle: "Enable or disable app notifications",
                            isLast: true,
                            trailing: Switch.adaptive(
                              value: controller.isNotificationsEnabled.value,
                              onChanged: (value) {
                                // controller.changeNotifications(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// =========================
                  /// SUPPORT
                  /// =========================
                  const _SectionTitle("Support"),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        ActionTile(
                          icon: Icons.info_outline_rounded,
                          title: "About Us",
                          subtitle: "Learn more about StoreX",
                          onTap: () {
                            showAboutStoreX(context);
                          },
                        ),
                        ActionTile(
                          icon: Icons.support_agent_rounded,
                          title: "Contact Us",
                          subtitle: "Reach our support team",
                          onTap: () {
                            SupportOptionsTile.show(context);
                          },
                        ),
                        ActionTile(
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          subtitle: "Review our privacy practices",
                          onTap: () {
                            showPrivacyPolicy(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// =========================
                  /// APP INFO
                  /// =========================
                  const _SectionTitle("Application"),

                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        ActionTile(
                          onTap: () => {},
                          icon: Icons.verified_rounded,
                          title: "Version",
                          subtitle: "StoreX v1.0.0",
                          isLast: true,
                        ),
                      ],
                    ),
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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
