import 'package:flutter/material.dart';
import 'package:reciep/theme/app_spacing.dart';

class HomeQuickActionsRow extends StatelessWidget {
  const HomeQuickActionsRow({
    super.key,
    required this.onScanReceipt,
    required this.onUploadReceipt,
  });

  final VoidCallback onScanReceipt;
  final VoidCallback onUploadReceipt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onScanReceipt,
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Scan Receipt'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          height: 46,
          width: 46,
          child: GestureDetector(
            onTap: onUploadReceipt,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Icon(
                Icons.ios_share_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
