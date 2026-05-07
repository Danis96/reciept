import 'package:flutter/material.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:refyn/app/features/budgets/ui/widgets/category_budget_sheet_content.dart';
import 'package:refyn/app/features/budgets/ui/utils/budget_formatting.dart';

import '../../action_utils/budgets_action_utils.dart';

class CategoryBudgetManagerSheet extends StatefulWidget {
  const CategoryBudgetManagerSheet({
    super.key,
    required this.supportedCategories,
    required this.currentAmounts,
    required this.onSave,
    required this.onDelete,
  });

  final List<String> supportedCategories;
  final Map<String, double> currentAmounts;
  final Future<void> Function(String category, double amount) onSave;
  final Future<void> Function(String category) onDelete;

  @override
  State<CategoryBudgetManagerSheet> createState() =>
      _CategoryBudgetManagerSheetState();
}

class _CategoryBudgetManagerSheetState
    extends State<CategoryBudgetManagerSheet> {
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, FocusNode> _focusNodes;
  late final Map<String, GlobalKey> _fieldKeys;
  late final Map<String, double> _currentAmounts;
  final Set<String> _busyCategories = <String>{};
  final Set<String> _successCategories = <String>{};
  late final BudgetsActionUtils _actionUtils;

  @override
  void initState() {
    super.initState();
    _currentAmounts = {
      for (final entry in widget.currentAmounts.entries)
        CategoryBudgetCatalog.normalize(entry.key): entry.value,
    };

    _controllers = {
      for (final category in widget.supportedCategories)
        category: TextEditingController(
          text: _currentAmounts[category] == null
              ? ''
              : CategoryBudgetMoney.formatDecimalConditionally(_currentAmounts[category]!),
        ),
    };

    _focusNodes = {
      for (final category in widget.supportedCategories)
        category: FocusNode()
          ..addListener(() => _actionUtils.handleFieldFocus(category)),
    };

    _fieldKeys = {
      for (final category in widget.supportedCategories) category: GlobalKey(),
    };

    _actionUtils = BudgetsActionUtils(
      context: context,
      controllers: _controllers,
      focusNodes: _focusNodes,
      fieldKeys: _fieldKeys,
      currentAmounts: _currentAmounts,
      busyCategories: _busyCategories,
      successCategories: _successCategories,
      setState: setState,
      onSaveCallback: widget.onSave,
      onDeleteCallback: widget.onDelete,
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 34 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: CategoryBudgetSheetContent(
        supportedCategories: widget.supportedCategories,
        currentAmounts: _currentAmounts,
        controllers: _controllers,
        focusNodes: _focusNodes,
        fieldKeys: _fieldKeys,
        busyCategories: _busyCategories,
        successCategories: _successCategories,
        onSave: _actionUtils.onSave,
        onDelete: _actionUtils.onDelete,
      ),
    );
  }
}
