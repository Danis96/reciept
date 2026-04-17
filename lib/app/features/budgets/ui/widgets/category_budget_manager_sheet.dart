import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';
import 'package:reciep/app/widgets/category_asset_image.dart';
import 'package:reciep/theme/app_spacing.dart';
import 'package:reciep/theme/category_palette.dart';

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

  @override
  void initState() {
    super.initState();
    _currentAmounts = <String, double>{
      for (final MapEntry<String, double> entry
          in widget.currentAmounts.entries)
        CategoryBudgetCatalog.normalize(entry.key): entry.value,
    };
    _controllers = <String, TextEditingController>{
      for (final String category in widget.supportedCategories)
        category: TextEditingController(
          text: _currentAmounts[category] == null
              ? ''
              : _CategoryBudgetMoney.formatInt(_currentAmounts[category]!),
        ),
    };
    _focusNodes = <String, FocusNode>{
      for (final String category in widget.supportedCategories)
        category: FocusNode()..addListener(() => _handleFieldFocus(category)),
    };
    _fieldKeys = <String, GlobalKey>{
      for (final String category in widget.supportedCategories)
        category: GlobalKey(),
    };
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    for (final FocusNode focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double keyboardInset = mediaQuery.viewInsets.bottom;
    final int activeBudgets = _currentAmounts.values
        .where((double amount) => amount > 0)
        .length;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.translate(
          offset: Offset(0, 34 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: _CategoryBudgetSheetPalette.cardBorder(context),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.92),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md + mediaQuery.padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.16,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CategoryBudgetSheetHeader(activeBudgets: activeBudgets),
                  const SizedBox(height: AppSpacing.md),
                  ...widget.supportedCategories.map(
                    (String category) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: CategoryBudgetSheetRow(
                        category: category,
                        controller: _controllers[category]!,
                        focusNode: _focusNodes[category]!,
                        fieldKey: _fieldKeys[category]!,
                        busy: _busyCategories.contains(category),
                        showSuccess: _successCategories.contains(category),
                        currentAmount: _currentAmounts[category],
                        onSave: () => _onSave(category),
                        onDelete: () => _onDelete(category),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleFieldFocus(String category) {
    final FocusNode? focusNode = _focusNodes[category];
    final BuildContext? fieldContext = _fieldKeys[category]?.currentContext;
    if (focusNode == null || !focusNode.hasFocus || fieldContext == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: 0.2,
      );
    });
  }

  Future<void> _onSave(String category) async {
    final String text = _controllers[category]!.text.trim();
    final double? parsed = double.tryParse(text);
    if (parsed == null || parsed < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid budget amount.')),
      );
      return;
    }

    setState(() {
      _busyCategories.add(category);
    });
    try {
      await widget.onSave(category, parsed);
      if (!mounted) {
        return;
      }
      setState(() {
        _currentAmounts[category] = parsed;
      });
      _showSaved(category);
    } finally {
      if (mounted) {
        setState(() {
          _busyCategories.remove(category);
        });
      }
    }
  }

  Future<void> _onDelete(String category) async {
    setState(() {
      _busyCategories.add(category);
    });
    try {
      await widget.onDelete(category);
      if (!mounted) {
        return;
      }
      _controllers[category]!.text = '';
      setState(() {
        _currentAmounts.remove(category);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_CategoryBudgetLabel.shortLabel(category)} budget deleted.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busyCategories.remove(category);
        });
      }
    }
  }

  void _showSaved(String category) {
    setState(() {
      _successCategories.add(category);
    });
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _successCategories.remove(category);
        });
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_CategoryBudgetLabel.shortLabel(category)} budget saved.',
        ),
      ),
    );
  }
}

class CategoryBudgetSheetHeader extends StatelessWidget {
  const CategoryBudgetSheetHeader({super.key, required this.activeBudgets});

  final int activeBudgets;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _CategoryBudgetSheetPalette.heroGradient(context),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Category Budgets',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Set monthly limits by category. Save each card when ready.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.74),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Text(
                    '$activeBudgets active budgets',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Material(
            color: Colors.white.withValues(alpha: 0.12),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBudgetSheetRow extends StatelessWidget {
  const CategoryBudgetSheetRow({
    super.key,
    required this.category,
    required this.controller,
    required this.focusNode,
    required this.fieldKey,
    required this.busy,
    required this.showSuccess,
    required this.currentAmount,
    required this.onSave,
    required this.onDelete,
  });

  final String category;
  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey fieldKey;
  final bool busy;
  final bool showSuccess;
  final double? currentAmount;
  final Future<void> Function() onSave;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = CategoryPalette.primaryFor(category, context);
    final String currentAmountLabel = currentAmount == null
        ? 'No budget set'
        : '${_CategoryBudgetMoney.formatInt(currentAmount!)} KM active';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _CategoryBudgetSheetPalette.cardBorder(context),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CategoryPalette.surfaceFor(category, context),
                ),
                child: ClipOval(
                  child: CategoryAssetImage(category: category, size: 44),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _CategoryBudgetLabel.shortLabel(category),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentAmountLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: busy
                    ? SizedBox(
                        key: const ValueKey<String>('busy'),
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: accent,
                        ),
                      )
                    : showSuccess
                    ? Container(
                        key: const ValueKey<String>('success'),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: accent.withValues(alpha: 0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey<String>('idle'),
                        width: 22,
                        height: 22,
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          KeyedSubtree(
            key: fieldKey,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                // filled: true,
                // fillColor: CategoryPalette.surfaceFor(category, context),
                prefixIcon: Icon(Icons.wallet_outlined, color: accent),
                suffixText: 'KM',
                hintText: 'Enter monthly budget',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _CategoryBudgetSheetPalette.cardBorder(context),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: _CategoryBudgetSheetPalette.cardBorder(context),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: accent, width: 1.4),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: busy ? null : () => onDelete(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _CategoryBudgetSheetPalette.danger(
                      context,
                    ),
                    side: BorderSide(
                      color: _CategoryBudgetSheetPalette.danger(
                        context,
                      ).withValues(alpha: 0.28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Clear'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: busy ? null : () => onSave(),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBudgetMoney {
  const _CategoryBudgetMoney._();

  static String formatInt(double value) {
    return NumberFormat('0').format(value);
  }
}

class _CategoryBudgetLabel {
  const _CategoryBudgetLabel._();

  static String shortLabel(String category) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.groceries:
        return 'Groceries';
      case CategoryBudgetCatalog.fuel:
        return 'Fuel';
      case CategoryBudgetCatalog.household:
        return 'Household';
      case CategoryBudgetCatalog.pets:
        return 'Pets';
      case CategoryBudgetCatalog.clothing:
        return 'Clothing';
      case CategoryBudgetCatalog.pharmacy:
        return 'Pharmacy';
      case CategoryBudgetCatalog.dental:
        return 'Dental';
      case CategoryBudgetCatalog.miscellaneous:
        return 'Misc';
    }
    return 'Misc';
  }
}

class _CategoryBudgetSheetPalette {
  const _CategoryBudgetSheetPalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> heroGradient(BuildContext context) {
    if (_dark(context)) {
      return const <Color>[Color(0xFF12172B), Color(0xFF222B48)];
    }
    return const <Color>[Color(0xFF171727), Color(0xFF2A2A43)];
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }

  static Color danger(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }
}
