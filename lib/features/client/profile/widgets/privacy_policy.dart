import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPrivacyPolicy(BuildContext context) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final media = MediaQuery.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) {
      return SafeArea(
        child: SizedBox(
          height: media.size.height * 0.8,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.privacy_tip_rounded,
                    size: 42,
                    color: cs.primary,
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    "Privacy Policy".tr,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "Your Privacy Matters".tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "At smartware, we value your trust and are committed to protecting your personal information. We collect and process data only when necessary to provide our services and improve your experience within the application."
                      .tr,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
                ),

                const SizedBox(height: 24),

                Text(
                  "Information We Collect".tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Depending on how you use smartware, we may collect account information, profile details, language preferences, and other data required to deliver core functionality and enhance the overall user experience."
                      .tr,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
                ),

                const SizedBox(height: 24),

                Text(
                  "Security & Protection".tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "We take appropriate measures to safeguard your information and continuously work to maintain the security and reliability of our platform."
                      .tr,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
                ),

                const SizedBox(height: 24),

                Text(
                  "Learn More".tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "For complete details about our privacy practices, data handling, and your rights, please visit our official website."
                      .tr,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: Open Privacy Policy URL
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text("Read the Full Privacy Policy".tr),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
