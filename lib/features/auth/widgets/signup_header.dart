import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
              const SizedBox(height: 10),
        Text(
          "StoreX",
          style: const TextStyle(
            fontFamily: 'Michroma',
            fontSize: 28,
            letterSpacing: 1.2,
          ).copyWith(color: colors.primary),
        ),

        const SizedBox(height: 10),

        Text(
          "Create Account".tr,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurface.withOpacity(0.6),
            fontSize: 20,
          ),
        ),
        Text(
                                          "Tell us about yourself and your business"
                                              .tr,

                                          style: theme
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: colors.onSurface
                                                    .withOpacity(0.6),
                                                height: 1.4,
                                              ),
                                        ),
      ],
    );
  }
}