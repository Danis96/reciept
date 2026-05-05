import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';

import '../utils/settings_pallete.dart';

class SettingsTitleBlock extends StatelessWidget {
  const SettingsTitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.settings,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}
