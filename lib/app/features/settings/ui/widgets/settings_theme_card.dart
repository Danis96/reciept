import 'package:flutter/material.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_dropdown_surface.dart';
import 'package:reciep/app/features/settings/ui/widgets/shared/settings_section_header.dart';

class SettingsThemeCard extends StatelessWidget {
  const SettingsThemeCard({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(
            icon: Icons.palette_outlined,
            title: 'Theme',
          ),
          const SizedBox(height: 16),
          SettingsDropdownSurface(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ThemeMode>(
                value: selectedMode,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFA8AAB8),
                ),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                borderRadius: BorderRadius.circular(10),
                items: const <DropdownMenuItem<ThemeMode>>[
                  DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.dark, child: Text('Dark')),
                  DropdownMenuItem<ThemeMode>(
                      value: ThemeMode.system, child: Text('System')),
                ],
                onChanged: (ThemeMode? value) {
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
