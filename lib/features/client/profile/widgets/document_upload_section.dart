import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';

class DocumentUploadSection extends StatelessWidget {
  const DocumentUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();

    return Column(
      children: [
        Obx(
          () => _DocumentUploadCard(
            title: 'Owner ID',
            subtitle:
                'Upload a clear copy of the owner\'s national ID or passport.',
            icon: Icons.badge_outlined,
            isUploaded: controller.ownerIdUploaded.value,
            onUpload: () => controller.pickDocument('owner_id'),
            onRemove: controller.removeOwnerId,
          ),
        ),

        const SizedBox(height: 20),

        Obx(
          () => _DocumentUploadCard(
            title: 'Proof of Property Ownership',
            subtitle:
                'Upload any document proving ownership or authorization to use the property.',
            icon: Icons.description_outlined,
            isUploaded: controller.ownershipProofUploaded.value,
            onUpload: () => controller.pickDocument('ownership_proof'),
            onRemove: controller.removeOwnershipProof,
          ),
        ),
      ],
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isUploaded;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const _DocumentUploadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isUploaded,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded
              ? cs.primary.withValues(alpha: .35)
              : cs.primary.withValues(alpha: .15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isUploaded
            ? cs.primary.withValues(alpha: .10)
            : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isUploaded ? cs.primary : cs.onSurfaceVariant,
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (isUploaded)
                TextButton.icon(
                  onPressed: onRemove,
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.highlight_remove_rounded, size: 18),
                  label: const Text('Remove'),
                ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
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
          const SizedBox(height: 20),
          if (!isUploaded)
            SizedBox(
              width: double.infinity,
              child:OutlinedButton.icon(
  onPressed: onUpload,
  icon: const Icon(Icons.upload_file_outlined),
  label: const Text('Upload Document'),
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
    side: BorderSide(
      color: Theme.of(context).colorScheme.primary, // Your border color
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
            )
          else
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Document uploaded successfully',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              
              ],
            ),
        ],
      ),
    );
  }
}