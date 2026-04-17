import 'package:flutter/material.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_action_row_button.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_section_header.dart';

class SettingsExportCard extends StatelessWidget {
  const SettingsExportCard({
    super.key,
    required this.exporting,
    required this.onExportCsvPressed,
    required this.onExportJsonPressed,
  });

  final bool exporting;
  final VoidCallback onExportCsvPressed;
  final VoidCallback onExportJsonPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(
            icon: Icons.download_for_offline_outlined,
            title: 'Export Receipts',
          ),
          const SizedBox(height: 16),
          SettingsActionRowButton(
            title: 'Export as CSV',
            onTap: exporting ? null : onExportCsvPressed,
          ),
          const SizedBox(height: 10),
          SettingsActionRowButton(
            title: 'Export as JSON',
            onTap: exporting ? null : onExportJsonPressed,
          ),
        ],
      ),
    );
  }
}
