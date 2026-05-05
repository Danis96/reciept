import 'package:flutter/material.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';

class SettingsSimpleMessageDialog extends StatelessWidget {
  const SettingsSimpleMessageDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}
