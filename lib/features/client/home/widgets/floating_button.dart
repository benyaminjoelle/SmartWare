import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const FloatingButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface.withOpacity(0.94),
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 21,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }
}

