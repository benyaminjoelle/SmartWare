import 'package:flutter/material.dart';

class AppStepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const AppStepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final active = cs.primary;
    final done = cs.primary.withValues(alpha: 0.6);
    final pending = cs.outline.withValues(alpha: 0.25);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (i) {
          /// STEP CIRCLE
          if (i.isEven) {
            final index = i ~/ 2;

            final isDone = index < currentStep;
            final isActive = index == currentStep;

            return Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? done.withValues(alpha: 0.15)
                    : isActive
                        ? active
                        : Colors.transparent,
                border: Border.all(
                  color: isDone
                      ? done
                      : isActive
                          ? active
                          : pending,
                  width: isActive ? 2 : 1.2,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isDone
                      ? Icon(
                          Icons.check_rounded,
                          key: ValueKey("check$index"),
                          size: 18,
                          color: done,
                        )
                      : Text(
                          "${index + 1}",
                          key: ValueKey("num$index"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                ),
              ),
            );
          }

          /// CONNECTOR LINE
          final connectorIndex = (i - 1) ~/ 2;

          return Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: connectorIndex < currentStep ? done : pending,
              ),
            ),
          );
        }),
      ),
    );
  }
}