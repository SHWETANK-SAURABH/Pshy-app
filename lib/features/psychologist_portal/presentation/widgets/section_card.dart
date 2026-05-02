import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            if (icon != null)
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: (color ?? theme.colorScheme.primary).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color ?? theme.colorScheme.primary),
              ),
            if (icon != null) const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text(value, style: theme.textTheme.titleLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
