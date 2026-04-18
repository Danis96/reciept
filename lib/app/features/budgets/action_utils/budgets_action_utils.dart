import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/ui/utils/budget_formatting.dart';

class BudgetsActionUtils {
  final BuildContext context;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final Map<String, GlobalKey> fieldKeys;
  final Map<String, double> currentAmounts;
  final Set<String> busyCategories;
  final Set<String> successCategories;
  final Function(VoidCallback) setState;
  final Future<void> Function(String category, double amount) onSaveCallback;
  final Future<void> Function(String category) onDeleteCallback;

  const BudgetsActionUtils({
    required this.context,
    required this.controllers,
    required this.focusNodes,
    required this.fieldKeys,
    required this.currentAmounts,
    required this.busyCategories,
    required this.successCategories,
    required this.setState,
    required this.onSaveCallback,
    required this.onDeleteCallback,
  });

  void handleFieldFocus(String category) {
    final FocusNode? focusNode = focusNodes[category];
    final BuildContext? fieldContext = fieldKeys[category]?.currentContext;
    if (focusNode == null || !focusNode.hasFocus || fieldContext == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: 0.2,
      );
    });
  }

  Future<void> onSave(String category) async {
    final String text = controllers[category]!.text.trim();
    final double? parsed = double.tryParse(text);
    if (parsed == null || parsed < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid budget amount.')),
      );
      return;
    }

    setState(() => busyCategories.add(category));
    try {
      await onSaveCallback(category, parsed);
      if (!context.mounted) return;

      setState(() {
        currentAmounts[category] = parsed;
      });
      _showSaved(category);
    } finally {
      if (context.mounted) {
        setState(() => busyCategories.remove(category));
      }
    }
  }

  Future<void> onDelete(String category) async {
    setState(() => busyCategories.add(category));
    try {
      await onDeleteCallback(category);
      if (!context.mounted) return;

      controllers[category]!.text = '';
      setState(() {
        currentAmounts.remove(category);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${CategoryBudgetLabel.shortLabel(category)} budget deleted.',
          ),
        ),
      );
    } finally {
      if (context.mounted) {
        setState(() => busyCategories.remove(category));
      }
    }
  }

  void _showSaved(String category) {
    setState(() => successCategories.add(category));
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (context.mounted) {
        setState(() => successCategories.remove(category));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${CategoryBudgetLabel.shortLabel(category)} budget saved.',
        ),
      ),
    );
  }
}
