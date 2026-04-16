import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
