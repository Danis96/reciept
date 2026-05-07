import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/settings/action_utils/settings_action_utils.dart';
import 'package:refyn/app/features/settings/controllers/settings_controller.dart';
import 'package:refyn/app/features/settings/ui/utils/settings_pallete.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_card_frame.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_section_header.dart';
import 'package:refyn/l10n/app_localizations.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';

class SettingsAiConfigCard extends StatefulWidget {
  const SettingsAiConfigCard({super.key});

  @override
  State<SettingsAiConfigCard> createState() => _SettingsAiConfigCardState();
}

class _SettingsAiConfigCardState extends State<SettingsAiConfigCard> {
  late final TextEditingController _apiKeyController;
  SettingsController? _settingsController;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SettingsController controller = context.read<SettingsController>();
    if (_settingsController == controller) {
      return;
    }
    _settingsController?.removeListener(_syncApiKeyDraft);
    _settingsController = controller;
    _settingsController!.addListener(_syncApiKeyDraft);
    _syncApiKeyDraft();
  }

  @override
  void dispose() {
    _settingsController?.removeListener(_syncApiKeyDraft);
    _apiKeyController.dispose();
    super.dispose();
  }

  void _syncApiKeyDraft() {
    final SettingsController? controller = _settingsController;
    if (controller == null) {
      return;
    }
    if (_apiKeyController.text == controller.apiKeyDraft) {
      return;
    }
    _apiKeyController.value = TextEditingValue(
      text: controller.apiKeyDraft,
      selection: TextSelection.collapsed(offset: controller.apiKeyDraft.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = context.watch<SettingsController>();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isEditingCustomKey = _apiKeyController.text.trim().isNotEmpty;
    final bool shouldProtectBuiltInKeyDisplay =
        controller.hasProtectedDefaultApiKey && !isEditingCustomKey;

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
                      icon: Icons.auto_awesome_rounded,
                      title: context.l10n.aiConfiguration,
                    ),
                  ),
                  const _AiConfigInfoButton(),
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
            context.l10n.aiConfigurationDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
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
                      const SizedBox(height: 18),
                      Text(
                        context.l10n.apiKey,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          final bool isCompact = constraints.maxWidth < 430;

                          return Flex(
                            direction: isCompact
                                ? Axis.vertical
                                : Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: isCompact ? 0 : 1,
                                child: TextField(
                                  controller: _apiKeyController,
                                  enableInteractiveSelection:
                                      !shouldProtectBuiltInKeyDisplay,
                                  obscureText: shouldProtectBuiltInKeyDisplay
                                      ? true
                                      : !controller.isApiKeyVisible,
                                  onChanged: controller.updateApiKeyDraft,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    letterSpacing: controller.isApiKeyVisible
                                        ? 0
                                        : 1.1,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: shouldProtectBuiltInKeyDisplay
                                        ? context.l10n.builtInKeyActive
                                        : context.l10n.pasteGoogleAiKey,
                                    filled: true,
                                    fillColor:
                                        SettingsPagePalette.fieldBackground(
                                          context,
                                        ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: SettingsPagePalette.cardBorder(
                                          context,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: SettingsPagePalette.cardBorder(
                                          context,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: colorScheme.primary,
                                        width: 1.4,
                                      ),
                                    ),
                                    suffixIcon: shouldProtectBuiltInKeyDisplay
                                        ? null
                                        : IconButton(
                                            onPressed: controller
                                                .toggleApiKeyVisibility,
                                            icon: Icon(
                                              controller.isApiKeyVisible
                                                  ? Icons
                                                        .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                            ),
                                          ),
                                    helperText: shouldProtectBuiltInKeyDisplay
                                        ? context.l10n.defaultKeyHiddenHelper
                                        : null,
                                    helperMaxLines: 2,
                                    helperStyle: theme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: isCompact ? 0 : 12,
                                height: isCompact ? 12 : 0,
                              ),
                              FilledButton(
                                onPressed: controller.isApiKeyConfirmed
                                    ? controller.canResetAiConfiguration
                                          ? () =>
                                                SettingsActionUtils.resetAiConfiguration(
                                                  context,
                                                )
                                          : null
                                    : controller.canConfirmApiKey
                                    ? () => SettingsActionUtils.confirmApiKey(
                                        context,
                                      )
                                    : null,
                                style: FilledButton.styleFrom(
                                  minimumSize: Size(
                                    isCompact ? double.infinity : 118,
                                    52,
                                  ),
                                  backgroundColor: controller.isApiKeyConfirmed
                                      ? colorScheme.surfaceContainerHighest
                                      : colorScheme.primary,
                                  foregroundColor: controller.isApiKeyConfirmed
                                      ? colorScheme.onSurface
                                      : colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: controller.isConfirmingApiKey
                                    ? const WigglyLoader.indeterminate(
                                        size: 20,
                                        arcSpan: 0.8,
                                        strokeWidth: 1,
                                        wiggleAmplitude: 1,
                                      )
                                    : Text(
                                        controller.isApiKeyConfirmed
                                            ? context.l10n.reset
                                            : context.l10n.confirm,
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      _StatusSwitcher(controller: controller),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.topCenter,
                        child: controller.hasModelSelection
                            ? Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: _ModelSelectionSection(
                                  controller: controller,
                                ),
                              )
                            : const SizedBox.shrink(),
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

class _StatusSwitcher extends StatelessWidget {
  const _StatusSwitcher({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: controller.isLoadingAiConfiguration
          ? _StatusRow(
              key: const ValueKey<String>('loading'),
              color: colorScheme.primary,
              icon: const WigglyLoader.indeterminate(
                size: 20,
                arcSpan: 0.8,
                strokeWidth: 1,
                wiggleAmplitude: 1,
              ),
              label: AppLocalizations.of(context).loadingSavedAiConfiguration,
            )
          : controller.isConfirmingApiKey
          ? _StatusRow(
              key: const ValueKey<String>('confirming'),
              color: colorScheme.primary,
              icon: const WigglyLoader.indeterminate(
                size: 20,
                arcSpan: 0.8,
                strokeWidth: 1,
                wiggleAmplitude: 1,
              ),
              label: AppLocalizations.of(context).confirmingKeyWithGoogleAi,
            )
          : controller.isApiKeyConfirmed
          ? _StatusRow(
              key: const ValueKey<String>('confirmed'),
              color: const Color(0xFF2EBD73),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: AppLocalizations.of(
                context,
              ).aiModelsAvailableLabel(controller.availableModels.length),
            )
          : controller.hasProtectedDefaultApiKey
          ? _StatusRow(
              key: const ValueKey<String>('protected-default'),
              color: colorScheme.secondary,
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
              label: AppLocalizations.of(context).builtInKeyInUse,
            )
          : controller.aiConfigurationError != null
          ? _StatusRow(
              key: const ValueKey<String>('error'),
              color: colorScheme.error,
              icon: const Icon(Icons.error_outline_rounded, size: 18),
              label: AppLocalizations.of(context).savedKeyInvalid,
            )
          : _StatusRow(
              key: const ValueKey<String>('idle'),
              color: colorScheme.onSurfaceVariant,
              icon: const Icon(Icons.lock_outline_rounded, size: 18),
              label: AppLocalizations.of(context).noKeySet,
            ),
    );
  }
}

class _ModelSelectionSection extends StatelessWidget {
  const _ModelSelectionSection({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String? selectedModelId =
        controller.availableModels
                .where((option) => option.id == controller.selectedModelId)
                .length ==
            1
        ? controller.selectedModelId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.model,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.modelSelectionDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          key: ValueKey<String?>(selectedModelId),
          initialValue: selectedModelId,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: 220,
          dropdownColor: colorScheme.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: SettingsPagePalette.rowBackground(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: SettingsPagePalette.cardBorder(context),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: SettingsPagePalette.cardBorder(context),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.3),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
          items: controller.availableModels
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.id,
                  child: Text(
                    option.id,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
              .toList(growable: false),
          onChanged: controller.isSavingSelectedModel
              ? null
              : (String? value) {
                  if (value == null) {
                    return;
                  }
                  SettingsActionUtils.saveSelectedAiModel(context, value);
                },
        ),
        const SizedBox(height: 14),
        _ThinkingToggleTile(controller: controller),
      ],
    );
  }
}

class _ThinkingToggleTile extends StatelessWidget {
  const _ThinkingToggleTile({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: controller.isSavingThinkingMode ? 0.7 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: SettingsPagePalette.rowBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SettingsPagePalette.cardBorder(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.deeperThinking,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.isThinkingEnabled
                        ? context.l10n.deeperThinkingOn
                        : context.l10n.deeperThinkingOff,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: controller.isThinkingEnabled,
              onChanged: controller.isSavingThinkingMode
                  ? null
                  : (bool value) => SettingsActionUtils.saveAiThinkingEnabled(
                      context,
                      value,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required Key super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        IconTheme(
          data: IconThemeData(color: color),
          child: icon,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _AiConfigInfoButton extends StatelessWidget {
  const _AiConfigInfoButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showInfoModal(context),
      icon: const Icon(Icons.info_outline_rounded),
      iconSize: 20,
      visualDensity: VisualDensity.compact,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      tooltip: context.l10n.howAiConfigurationWorks,
    );
  }

  static void _showInfoModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AiConfigInfoSheet(),
    );
  }
}

class _AiConfigInfoSheet extends StatefulWidget {
  const _AiConfigInfoSheet();

  @override
  State<_AiConfigInfoSheet> createState() => _AiConfigInfoSheetState();
}

class _AiConfigInfoSheetState extends State<_AiConfigInfoSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future<void>.delayed(const Duration(milliseconds: 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double maxSheetHeight = MediaQuery.sizeOf(context).height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SettingsPagePalette.cardBorder(context)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Flexible(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: ClipOval(child: Image.asset('assets/app_icon/receipt_app_icon_clean.png', fit: .contain)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  context.l10n.aiConfiguration,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.l10n.aiInfoSubtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.public_rounded,
                        title: AppLocalizations.of(context).bringYourOwnKey,
                        body: AppLocalizations.of(context).bringYourOwnKeyBody,
                      ),
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.shield_outlined,
                        title: AppLocalizations.of(context).staysOnDevice,
                        body: AppLocalizations.of(context).staysOnDeviceBody,
                      ),
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.bolt_rounded,
                        title: AppLocalizations.of(context).quotaIsYours,
                        body: AppLocalizations.of(context).quotaIsYoursBody,
                      ),
                      const SizedBox(height: 10),
                      _InfoCard(
                        icon: Icons.model_training_rounded,
                        title: AppLocalizations.of(context).pickGemmaModel,
                        body: AppLocalizations.of(context).pickGemmaModelBody,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: SettingsPagePalette.rowBackground(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: SettingsPagePalette.cardBorder(context),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              context.l10n.quickSteps,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.l10n.quickStep1,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.quickStep2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.quickStep3,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.quickStep4,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: Text(context.l10n.gotIt),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SettingsPagePalette.rowBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SettingsPagePalette.cardBorder(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
