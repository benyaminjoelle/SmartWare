import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Widget? suffix;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool isPassword;
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
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: colors.onSurface,
                letterSpacing: 0.2,
              ),
            ),
            if (suffix != null) suffix!,
          ],
        ),

        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: isPassword,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,

            // ✅ Removed immediate validation
            autovalidateMode: AutovalidateMode.disabled,

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),

              suffixIcon: suffixIcon,

              filled: true,
              fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.18),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colors.outline.withValues(alpha: 0.15),
                  width: 1.2,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colors.primary,
                  width: 1.8,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colors.error,
                  width: 1.2,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colors.error,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}