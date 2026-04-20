import 'package:flutter/material.dart';
import 'package:reciep/app/features/history/ui/utils/history_ui_utils.dart';
import 'package:reciep/theme/app_spacing.dart';

class HistorySearchBar extends StatefulWidget {
  const HistorySearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant HistorySearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: HistoryThemePalette.inputBackground(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: 'Search by merchant, item, or category...',
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.secondary.withValues(alpha: 0.78),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
