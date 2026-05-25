import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: media.padding.top + 5,
        start: 10,
      ),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 23,
          ),
          onPressed: onPressed ?? () => Get.back(),
        ),
      ),
    );
  }
}