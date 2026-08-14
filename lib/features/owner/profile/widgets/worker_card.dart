import 'package:flutter/material.dart';

import 'package:smartware/features/owner/profile/controllers/owner_workers_controller.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback onRemove;

  const WorkerCard({
    super.key,
    required this.worker,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: .12),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WorkerAvatar(
                initials: worker.initials,
                size: isCompact ? 46 : 52,
              ),
              SizedBox(width: isCompact ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      worker.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Phone: Pending',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const WorkerPendingBadge(),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              WorkerOptionsButton(onRemove: onRemove),
            ],
          );
        },
      ),
    );
  }
}

class WorkerAvatar extends StatelessWidget {
  final String initials;
  final double size;

  const WorkerAvatar({
    super.key,
    required this.initials,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: .10),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class WorkerPendingBadge extends StatelessWidget {
  const WorkerPendingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 14,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 5),
          Text(
            'Pending',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerOptionsButton extends StatelessWidget {
  final VoidCallback onRemove;

  const WorkerOptionsButton({
    super.key,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Worker options',
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'remove') {
          onRemove();
        }
      },
      itemBuilder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return [
          PopupMenuItem<String>(
            value: 'remove',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 10),
                Text(
                  'Remove Worker',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
