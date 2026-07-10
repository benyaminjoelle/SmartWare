import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingText extends StatelessWidget {
  const OnboardingText({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final titleSize = textScaler.scale(30).clamp(28.0, 46.0);
    final taglineSize = textScaler.scale(12).clamp(10.0, 20.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Boxed",
          style: TextStyle(
            fontFamily: 'Michroma',
            fontSize: titleSize,
            color: colors.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your choice for a smart warehouse".tr,
          style: TextStyle(
            fontSize: taglineSize,
            color: Colors.grey,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
