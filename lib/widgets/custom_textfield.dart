import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Widget? suffix;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onToggleVisibility;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.suffix,
    this.hint = '',
    this.controller,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.isObscure = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.sizeOf(context);

    final horizontalPadding = size.width * 0.045;
    final verticalPadding = size.height * 0.02;
    final borderRadius = size.width * 0.024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ),
            if (suffix != null) suffix!,
          ],
        ),

        SizedBox(height: size.height * 0.012),

        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isPassword ? isObscure : false,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
      

          style: textTheme.bodyLarge?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
          ),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.6),
            ),

            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  )
                : suffixIcon,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: colors.surfaceContainerHighest.withOpacity(0.2),

            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colors.outline.withOpacity(0.15),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colors.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colors.error,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: colors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}