import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refyn/app/features/settings/ui/utils/settings_pallete.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_section_header.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';

class SettingsCurrencyCard extends StatefulWidget {
  const SettingsCurrencyCard({
    super.key,
    required this.selectedCode,
    required this.onChanged,
  });

  final String selectedCode;
  final ValueChanged<String> onChanged;

  @override
  State<SettingsCurrencyCard> createState() => _SettingsCurrencyCardState();
}

class _SettingsCurrencyCardState extends State<SettingsCurrencyCard> {
  final TextEditingController _customController = TextEditingController();
  final FocusNode _customFocusNode = FocusNode();
  bool _isExpanded = true;

  static const List<_CurrencyPreset> _presets = <_CurrencyPreset>[
    _CurrencyPreset(code: 'BAM', label: 'BAM', flag: '\u{1F1E7}\u{1F1E6}'),
    _CurrencyPreset(code: 'EUR', label: 'EUR', flag: '\u{1F1EA}\u{1F1FA}'),
    _CurrencyPreset(code: 'USD', label: 'USD', flag: '\u{1F1FA}\u{1F1F8}'),
    _CurrencyPreset(code: 'GBP', label: 'GBP', flag: '\u{1F1EC}\u{1F1E7}'),
    _CurrencyPreset(code: 'DKK', label: 'DKK', flag: '\u{1F1E9}\u{1F1F0}'),
    _CurrencyPreset(code: 'SEK', label: 'SEK', flag: '\u{1F1F8}\u{1F1EA}'),
    _CurrencyPreset(code: 'NOK', label: 'NOK', flag: '\u{1F1F3}\u{1F1F4}'),
    _CurrencyPreset(code: 'CHF', label: 'CHF', flag: '\u{1F1E8}\u{1F1ED}'),
    _CurrencyPreset(code: 'HRK', label: 'HRK', flag: '\u{1F1ED}\u{1F1F7}'),
    _CurrencyPreset(code: 'RSD', label: 'RSD', flag: '\u{1F1F7}\u{1F1F8}'),
    _CurrencyPreset(code: 'TRY', label: 'TRY', flag: '\u{1F1F9}\u{1F1F7}'),
    _CurrencyPreset(code: 'PLN', label: 'PLN', flag: '\u{1F1F5}\u{1F1F1}'),
  ];

  bool get _isCustom =>
      !_presets.any((_CurrencyPreset p) => p.code == widget.selectedCode);

  bool get _canSaveCustom {
    final String normalized = _customController.text.trim().toUpperCase();
    return normalized.length >= 2 && normalized != widget.selectedCode;
  }

  @override
  void initState() {
    super.initState();
    _customController.addListener(_handleCustomChanged);
    _customFocusNode.addListener(_handleCustomChanged);
    if (_isCustom) {
      _customController.text = widget.selectedCode;
    }
  }

  @override
  void didUpdateWidget(covariant SettingsCurrencyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCode != widget.selectedCode && _isCustom) {
      _customController.text = widget.selectedCode;
    }
  }

  @override
  void dispose() {
    _customController.removeListener(_handleCustomChanged);
    _customFocusNode.removeListener(_handleCustomChanged);
    _customController.dispose();
    _customFocusNode.dispose();
    super.dispose();
  }

  void _handleCustomChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onPresetTapped(String code) {
    _customController.clear();
    _customFocusNode.unfocus();
    setState(() {});
    widget.onChanged(code);
  }

  void _onCustomSubmitted(String value) {
    final String normalized = value.trim().toUpperCase();
    if (normalized.isNotEmpty && normalized.length >= 2) {
      _customFocusNode.unfocus();
      widget.onChanged(normalized);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SettingsSectionHeader(
                      icon: Icons.currency_exchange_rounded,
                      title: context.l10n.currency,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.currencyDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: SettingsPagePalette.mutedText(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              theme.colorScheme.primary.withValues(alpha: 0.10),
                              theme.colorScheme.secondary.withValues(
                                alpha: 0.08,
                              ),
                            ],
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.14,
                                ),
                              ),
                              child: Icon(
                                Icons.wallet_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    context.l10n.currency,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: SettingsPagePalette.mutedText(
                                        context,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.selectedCode,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _presets
                            .map(
                              (_CurrencyPreset preset) => _CurrencyChip(
                                preset: preset,
                                selected: widget.selectedCode == preset.code,
                                onTap: () => _onPresetTapped(preset.code),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: SettingsPagePalette.fieldBackground(context),
                          border: Border.all(
                            color: _customFocusNode.hasFocus
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.34,
                                  )
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.08,
                                  ),
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.86,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _customController,
                                focusNode: _customFocusNode,
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'),
                                  ),
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: InputDecoration(
                                  hintText: context.l10n.currencyCustomHint,
                                  hintStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.35),
                                      ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                                onSubmitted: _onCustomSubmitted,
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: _canSaveCustom ? 1 : 0.45,
                              child: IgnorePointer(
                                ignoring: !_canSaveCustom,
                                child: GestureDetector(
                                  onTap: () => _onCustomSubmitted(
                                    _customController.text,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.22),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      context.l10n.save,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _CurrencyPreset {
  const _CurrencyPreset({
    required this.code,
    required this.label,
    required this.flag,
  });

  final String code;
  final String label;
  final String flag;
}

class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final _CurrencyPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color activeColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? activeColor.withValues(alpha: 0.12)
              : SettingsPagePalette.fieldBackground(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? activeColor
                : theme.colorScheme.onSurface.withValues(alpha: 0.10),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(preset.flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              preset.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? activeColor : theme.colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
