import 'package:flutter/material.dart';

import '../../utils/settings_pallete.dart';

class SettingsActionRowButton extends StatelessWidget {
  const SettingsActionRowButton({
    super.key,
    required this.title,
    required this.onTap,
    this.highlighted = false,
  });

  final String title;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Ink(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SettingsPagePalette.cardBorder(context)),
          color: highlighted
              ? SettingsPagePalette.rowHighlightBackground(context)
              : SettingsPagePalette.rowBackground(context),
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
