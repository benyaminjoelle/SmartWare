
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/core/constants/app_colors.dart';

class PersonalPhotoPicker extends StatelessWidget {
  const PersonalPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientSignupController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final image = controller.personalPhoto.value;

      return Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// MAIN AVATAR
            GestureDetector(
              onTap: () {
                if (image != null) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.85),
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
                } else {
                  controller.pickPersonalPhoto();
                }
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 120,
                height: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.primary.withOpacity(0.35),
                    width: 2,
                  ),
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),

                child: image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            color: cs.primary,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add Photo",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),

            /// MENU BUTTON
            if (image != null)
              Positioned(
                top: -6,
                right: -6,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),

                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.85),
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: InteractiveViewer(
                                child: Image.file(image),
                              ),
                            ),
                          ),
                        );
                        break;

                      case 'change':
                        controller.pickPersonalPhoto();
                        break;

                      case 'delete':
                        controller.personalPhoto.value = null;
                        break;
                    }
                  },

                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text("View"),
                    ),
                    const PopupMenuItem(
                      value: 'change',
                      child: Text("Change"),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        "Remove",
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}