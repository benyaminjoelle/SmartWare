import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/widgets/back_button.dart';

class SignupOnboardingHeader extends StatelessWidget {
  const SignupOnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);

    final titleSize = textScaler.scale(28).clamp(26.0, 44.0);
    final bodySize = textScaler.scale(12).clamp(10.0, 18.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
     
        CustomBackButton(),

        const SizedBox(height: 12),

        /// 🧠 Brand
        Text(
          "StoreX",
          style: TextStyle(
            fontFamily: 'Michroma',
            fontSize: titleSize,
            color: colors.primary,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 16),


        /// 🌿 Subtitle
        Text(
          "Choose your account type to get started with StoreX".tr,
          style: TextStyle(
            fontSize: bodySize,
            color: colors.onSurface.withOpacity(0.6),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}