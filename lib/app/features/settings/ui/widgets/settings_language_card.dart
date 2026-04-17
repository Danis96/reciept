import 'package:flutter/material.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_dropdown_surface.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_section_header.dart';

class SettingsLanguageCard extends StatelessWidget {
  const SettingsLanguageCard({
    super.key,
    required this.languageCode,
    required this.onChanged,
  });

  final String languageCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(icon: Icons.language, title: 'Language'),
          const SizedBox(height: 16),
          SettingsDropdownSurface(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: languageCode,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFA8AAB8)),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                borderRadius: BorderRadius.circular(10),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(value: 'en', child: Text('English')),
                  DropdownMenuItem<String>(value: 'bs', child: Text('Bosnian')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
