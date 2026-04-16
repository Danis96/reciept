import 'package:flutter/material.dart';

class ScanHeaderSection extends StatelessWidget {
  const ScanHeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
