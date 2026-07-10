import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppImagePicker extends StatelessWidget {
  final Rx<File?> image;
  final VoidCallback onPick;
  final VoidCallback? onRemove;
  final double size;
  final bool enablePreview;

  const AppImagePicker({
    super.key,
    required this.image,
    required this.onPick,
    this.onRemove,
    this.size = 120,
    this.enablePreview = true,
  });

  void _showPreview(
    BuildContext context,
    File image,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .9),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: InteractiveViewer(
              child: Image.file(image),
            ),
          ),
        );
      },
    );
  }

  void _showActionsSheet(
    BuildContext context,
    File image,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionTile(
                  icon: Icons.visibility_rounded,
                  title: "View Photo",
                  onTap: () {
                    Get.back();
                    _showPreview(context, image);
                  },
                ),

                _ActionTile(
                  icon: Icons.edit_rounded,
                  title: "Change Photo",
                  onTap: () {
                    Get.back();
                    onPick();
                  },
                ),

                if (onRemove != null)
                  _ActionTile(
                    icon: Icons.delete_outline_rounded,
                    title: "Remove Photo",
                    isDestructive: true,
                    onTap: () {
                      Get.back();
                      onRemove!.call();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final selectedImage = image.value;

      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (selectedImage != null &&
                  enablePreview) {
                _showPreview(
                  context,
                  selectedImage,
                );
              } else {
                onPick();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.primary.withValues(
                    alpha: .25,
                  ),
                  width: 2,
                ),
                
                
                image: selectedImage != null
                    ? DecorationImage(
                        image: FileImage(
                          selectedImage,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: selectedImage == null
                  ? Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          color: cs.primary,
                          size: size * .22,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Add Photo",
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: cs.primary,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(100),
                onTap: () {
                  if (selectedImage == null) {
                    onPick();
                  } else {
                    _showActionsSheet(
                      context,
                      selectedImage,
                    );
                  }
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          theme.scaffoldBackgroundColor,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary
                            .withValues(alpha: .25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    selectedImage == null
                        ? Icons.add
                        : Icons.edit_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final color =
        isDestructive ? Colors.red : cs.primary;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium
            ?.copyWith(
          color: isDestructive
              ? Colors.red
              : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}