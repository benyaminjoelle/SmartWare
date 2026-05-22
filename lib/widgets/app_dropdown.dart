import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;

  final List<DropdownMenuItem<T>> items;

  final ValueChanged<T?>? onChanged;

  final String? Function(T?)? validator;

  final Widget? suffix;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.suffix,
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
        /// LABEL
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

        /// DROPDOWN
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,

          isExpanded: true,

         icon: value != null
    ? GestureDetector(
        onTap: () => onChanged?.call(null),
        child: Icon(
          Icons.close_rounded,
          color: colors.onSurface.withOpacity(0.6),
        ),
      )
    : Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colors.onSurface.withOpacity(0.7),
      ),

          style: textTheme.bodyLarge?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
          ),

          dropdownColor: colors.surface,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.6),
            ),

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