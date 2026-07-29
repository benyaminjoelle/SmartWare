import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/widgets/document_upload_section.dart';
import 'package:smartware/features/client/profile/widgets/documents_header.dart';
import 'package:smartware/widgets/app_dialog.dart';
import 'package:smartware/widgets/primary_button.dart';

class ClientDocumentations extends StatelessWidget {
  const ClientDocumentations({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DocumentsHeader(),

                const SizedBox(height: 32),
DocumentUploadSection(),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock_outline, color: cs.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your documents are secure',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'We use these documents only to verify your business account and protect our platform from fraud.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Obx(
          () => PrimaryButton(
            text: 'Continue',
            isDisabled: !controller.canGoNext,
            onPressed: () async {
  final confirmed = await AppDialogs.showConfirmDialog(
    title: 'Document Security',
    message:
        'Your uploaded documents will be securely stored and used only to verify your business account. By continuing, you agree to submit these documents for review.',
    confirmText: 'Continue',
    cancelText: 'Cancel',
    cancelColor: cs.error,
    confirmColor: Theme.of(context).colorScheme.primary,
    
  );

  if (confirmed == true) {
    controller.nextStep();
  }
},
          ),
        ),
      ],
    );
  }
}

