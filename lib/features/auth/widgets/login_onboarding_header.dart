import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOnboardingHeader extends StatelessWidget {
  const LoginOnboardingHeader({super.key});

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
          "Welcome Back!",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurface.withOpacity(0.6),
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}