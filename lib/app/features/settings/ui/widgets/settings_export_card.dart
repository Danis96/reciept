import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_action_row_button.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_section_header.dart';
import 'package:refyn/app/features/settings/ui/utils/settings_pallete.dart';

class SettingsExportCard extends StatefulWidget {
  const SettingsExportCard({
    super.key,
    required this.exporting,
    required this.receiptExporting,
    required this.importing,
    required this.clearing,
    required this.onExportCsvPressed,
    required this.onExportPdfPressed,
    required this.onEmailReceiptsPressed,
    required this.onExportBackupPressed,
    required this.onImportBackupPressed,
    required this.onClearDataPressed,
  });

  final bool exporting;
  final bool receiptExporting;
  final bool importing;
  final bool clearing;
  final VoidCallback onExportCsvPressed;
  final VoidCallback onExportPdfPressed;
  final VoidCallback onEmailReceiptsPressed;
  final VoidCallback onExportBackupPressed;
  final VoidCallback onImportBackupPressed;
  final VoidCallback onClearDataPressed;

  @override
  State<SettingsExportCard> createState() => _SettingsExportCardState();
}

class _SettingsExportCardState extends State<SettingsExportCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SettingsSectionHeader(
                      icon: Icons.download_for_offline_outlined,
                      title: context.l10n.export,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.settingsExportDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 12),
                      _SettingsExportSegment(
                        exporting: widget.receiptExporting,
                        onExportCsvPressed: widget.onExportCsvPressed,
                        onExportPdfPressed: widget.onExportPdfPressed,
                        onEmailReceiptsPressed: widget.onEmailReceiptsPressed,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        context.l10n.localDeviceData,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.localDeviceDataDescription,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingsActionRowButton(
                        title: widget.exporting
                            ? context.l10n.preparingBackup
                            : context.l10n.exportBackup,
                        onTap: widget.exporting
                            ? null
                            : widget.onExportBackupPressed,
                      ),
                      const SizedBox(height: 10),
                      SettingsActionRowButton(
                        title: widget.importing
                            ? context.l10n.importingBackup
                            : context.l10n.importBackup,
                        onTap: widget.importing
                            ? null
                            : widget.onImportBackupPressed,
                      ),
                      const SizedBox(height: 10),
                      SettingsActionRowButton(
                        title: widget.clearing
                            ? context.l10n.clearingData
                            : context.l10n.clearLocalData,
                        highlighted: true,
                        onTap: widget.clearing
                            ? null
                            : widget.onClearDataPressed,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SettingsExportSegment extends StatefulWidget {
  const _SettingsExportSegment({
    required this.exporting,
    required this.onExportCsvPressed,
    required this.onExportPdfPressed,
    required this.onEmailReceiptsPressed,
  });

  final bool exporting;
  final VoidCallback onExportCsvPressed;
  final VoidCallback onExportPdfPressed;
  final VoidCallback onEmailReceiptsPressed;

  @override
  State<_SettingsExportSegment> createState() => _SettingsExportSegmentState();
}

class _SettingsExportSegmentState extends State<_SettingsExportSegment> {
  _SettingsExportOption _selected = _SettingsExportOption.csv;

  @override
  Widget build(BuildContext context) {
    final _ExportCopy copy = _copyFor(context, _selected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: SettingsPagePalette.fieldBackground(context),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: _SettingsExportOption.values
                .map((option) {
                  final bool active = option == _selected;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active
                              ? Theme.of(context).colorScheme.surface
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option.label(context),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: SettingsPagePalette.cardBorder(context)),
            color: SettingsPagePalette.rowBackground(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                copy.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                copy.subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              SettingsActionRowButton(
                title: widget.exporting ? copy.loadingTitle : copy.actionTitle,
                onTap: widget.exporting ? null : () => _onActionTap(_selected),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onActionTap(_SettingsExportOption option) {
    switch (option) {
      case _SettingsExportOption.csv:
        widget.onExportCsvPressed();
        break;
      case _SettingsExportOption.pdf:
        widget.onExportPdfPressed();
        break;
      case _SettingsExportOption.email:
        widget.onEmailReceiptsPressed();
        break;
    }
  }

  _ExportCopy _copyFor(BuildContext context, _SettingsExportOption option) {
    switch (option) {
      case _SettingsExportOption.csv:
        return _ExportCopy(
          title: context.l10n.csvExportTitle,
          subtitle: context.l10n.csvExportSubtitle,
          actionTitle: context.l10n.exportCsv,
          loadingTitle: context.l10n.preparingCsv,
        );
      case _SettingsExportOption.pdf:
        return _ExportCopy(
          title: context.l10n.pdfReportTitle,
          subtitle: context.l10n.pdfReportSubtitle,
          actionTitle: context.l10n.exportPdf,
          loadingTitle: context.l10n.preparingPdf,
        );
      case _SettingsExportOption.email:
        return _ExportCopy(
          title: context.l10n.emailDraftTitle,
          subtitle: context.l10n.emailDraftSubtitle,
          actionTitle: context.l10n.composeEmail,
          loadingTitle: context.l10n.openingMail,
        );
    }
  }
}

enum _SettingsExportOption { csv, pdf, email }

extension on _SettingsExportOption {
  String label(BuildContext context) {
    switch (this) {
      case _SettingsExportOption.csv:
        return 'CSV';
      case _SettingsExportOption.pdf:
        return 'PDF';
      case _SettingsExportOption.email:
        return context.l10n.emailDraftTitle.split(' ').first;
    }
  }
}

class _ExportCopy {
  const _ExportCopy({
    required this.title,
    required this.subtitle,
    required this.actionTitle,
    required this.loadingTitle,
  });

  final String title;
  final String subtitle;
  final String actionTitle;
  final String loadingTitle;
}
