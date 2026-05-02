import 'package:flutter/material.dart';

import '../../domain/entities/session.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({
    super.key,
    required this.session,
    required this.onTap,
    required this.actionLabel,
    required this.onAction,
  });

  final Session session;
  final VoidCallback onTap;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.clientName,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Chip(
                    label: Text(session.status.toUpperCase()),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${session.dateTime.toLocal()}'.split('.').first,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(session.meetingLink, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(height: 14),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(actionLabel),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
