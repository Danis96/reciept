import 'package:flutter/material.dart';
import 'package:reciep/app/features/export/repository/receipt_export_service.dart';

class ReceiptActionToolbar extends StatelessWidget {
  const ReceiptActionToolbar({
    super.key,
    required this.hasImage,
    required this.deleting,
    required this.exporting,
    required this.onViewImage,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onExportSelected,
  });

  final bool hasImage;
  final bool deleting;
  final bool exporting;
  final VoidCallback onViewImage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Future<void> Function(ReceiptExportFormat format) onExportSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          ActionButton(
            icon: Icons.image_outlined,
            onTap: hasImage ? onViewImage : null,
          ),
          ActionButton(
            icon: Icons.edit_outlined,
            onTap: deleting ? null : onEdit,
          ),
          ActionButton(icon: Icons.share_outlined, onTap: onShare),
          ReceiptExportButton(
            exporting: exporting,
            onSelected: onExportSelected,
          ),
          ActionButton(
            icon: Icons.delete_outline_rounded,
            iconColor: colorScheme.error,
            borderColor: colorScheme.error.withValues(alpha: 0.28),
            onTap: deleting ? null : onDelete,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color resolvedIconColor = iconColor ?? colorScheme.onSurfaceVariant;
    final Color resolvedBorderColor =
        borderColor ?? colorScheme.outlineVariant.withValues(alpha: 0.7);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap == null
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: resolvedBorderColor),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? resolvedIconColor.withValues(alpha: 0.35)
              : resolvedIconColor,
        ),
      ),
    );
  }
}

class ReceiptExportButton extends StatelessWidget {
  const ReceiptExportButton({
    super.key,
    required this.exporting,
    required this.onSelected,
  });

  final bool exporting;
  final Future<void> Function(ReceiptExportFormat format) onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<ReceiptExportFormat>(
      tooltip: 'Export receipt',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<ReceiptExportFormat>>[
            const PopupMenuItem<ReceiptExportFormat>(
              value: ReceiptExportFormat.csv,
              child: Text('Export CSV'),
            ),
            const PopupMenuItem<ReceiptExportFormat>(
              value: ReceiptExportFormat.json,
              child: Text('Export JSON'),
            ),
          ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: exporting
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.file_download_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}
