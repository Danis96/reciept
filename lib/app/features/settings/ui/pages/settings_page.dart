import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/budgets/ui/widgets/category_budget_manager_sheet.dart';
import 'package:reciep/app/features/settings/action_utils/settings_action_utils.dart';
import 'package:reciep/app/features/settings/controllers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder:
          (BuildContext context, SettingsController controller, Widget? _) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SettingsTitleBlock(),
                    const SizedBox(height: 16),
                    SettingsThemeCard(
                      selectedMode: controller.themeMode,
                      onChanged: (ThemeMode mode) {
                        SettingsActionUtils.onThemeModeChanged(context, mode);
                      },
                    ),
                    const SizedBox(height: 14),
                    SettingsLanguageCard(
                      languageCode: controller.locale.languageCode,
                      onChanged: (String code) {
                        SettingsActionUtils.onLanguageChanged(
                          context,
                          Locale(code),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    SettingsExportCard(
                      exporting: controller.exporting,
                      onExportCsvPressed: () async {
                        final String path =
                            await SettingsActionUtils.onExportCsv(context);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CSV saved: $path')),
                          );
                        }
                      },
                      onExportJsonPressed: () async {
                        final String path =
                            await SettingsActionUtils.onExportJson(context);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('JSON saved: $path')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    SettingsBudgetCard(
                      monthlyBudget: controller.monthlyBudget,
                      onManagePressed: () async {
                        await showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext sheetContext) {
                            return CategoryBudgetManagerSheet(
                              supportedCategories:
                                  controller.supportedBudgetCategories,
                              currentAmounts: <String, double>{
                                for (final budget in controller.categoryBudgets)
                                  budget.category: budget.budgetAmount,
                              },
                              onSave: (String category, double amount) {
                                return SettingsActionUtils.onBudgetSaved(
                                  context,
                                  category: category,
                                  amount: amount,
                                );
                              },
                              onDelete: (String category) {
                                return SettingsActionUtils.onBudgetDeleted(
                                  context,
                                  category: category,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    const SettingsAboutCard(appVersion: _appVersion),
                    const SizedBox(height: 14),
                    const SettingsLegalCard(),
                  ],
                ),
              ),
            );
          },
    );
  }
}

class SettingsTitleBlock extends StatelessWidget {
  const SettingsTitleBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 44 / 2,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your preferences',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: SettingsPagePalette.mutedText(context),
          ),
        ),
      ],
    );
  }
}

class SettingsCardFrame extends StatelessWidget {
  const SettingsCardFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SettingsPagePalette.cardBorder(context)),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: child,
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 36 / 2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class SettingsDropdownSurface extends StatelessWidget {
  const SettingsDropdownSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: SettingsPagePalette.fieldBackground(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(child: child),
    );
  }
}

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
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
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

class SettingsLanguageCard extends StatelessWidget {
  const SettingsLanguageCard({
    super.key,
    required this.languageCode,
    required this.onChanged,
  });

  final String languageCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(icon: Icons.language, title: 'Language'),
          const SizedBox(height: 16),
          SettingsDropdownSurface(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: languageCode,
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
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(value: 'en', child: Text('English')),
                  DropdownMenuItem<String>(value: 'bs', child: Text('Bosnian')),
                ],
                onChanged: (String? value) {
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

class SettingsExportCard extends StatelessWidget {
  const SettingsExportCard({
    super.key,
    required this.exporting,
    required this.onExportCsvPressed,
    required this.onExportJsonPressed,
  });

  final bool exporting;
  final VoidCallback onExportCsvPressed;
  final VoidCallback onExportJsonPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(
            icon: Icons.download_for_offline_outlined,
            title: 'Export Receipts',
          ),
          const SizedBox(height: 16),
          SettingsActionRowButton(
            title: 'Export as CSV',
            onTap: exporting ? null : onExportCsvPressed,
          ),
          const SizedBox(height: 10),
          SettingsActionRowButton(
            title: 'Export as JSON',
            onTap: exporting ? null : onExportJsonPressed,
          ),
        ],
      ),
    );
  }
}

class SettingsActionRowButton extends StatelessWidget {
  const SettingsActionRowButton({
    super.key,
    required this.title,
    required this.onTap,
    this.highlighted = false,
  });

  final String title;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Ink(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: SettingsPagePalette.cardBorder(context)),
          color: highlighted
              ? SettingsPagePalette.rowHighlightBackground(context)
              : SettingsPagePalette.rowBackground(context),
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 32 / 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class SettingsBudgetCard extends StatelessWidget {
  const SettingsBudgetCard({
    super.key,
    required this.monthlyBudget,
    required this.onManagePressed,
  });

  final double monthlyBudget;
  final VoidCallback onManagePressed;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(
            icon: Icons.attach_money_rounded,
            title: 'Budget Settings',
          ),
          const SizedBox(height: 18),
          Text(
            'Monthly Budget (KM)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: SettingsPagePalette.fieldBackground(context),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              NumberFormat('0').format(monthlyBudget),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SettingsActionRowButton(
            title: 'Manage Category Budgets',
            onTap: onManagePressed,
          ),
        ],
      ),
    );
  }
}

class SettingsAboutCard extends StatelessWidget {
  const SettingsAboutCard({super.key, required this.appVersion});

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SettingsSectionHeader(icon: Icons.info_outline, title: 'About'),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text(
                'App Version',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SettingsPagePalette.mutedText(context),
                ),
              ),
              const Spacer(),
              Text(
                appVersion,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsLegalCard extends StatelessWidget {
  const SettingsLegalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardFrame(
      child: Column(
        children: <Widget>[
          SettingsLegalRow(
            icon: Icons.verified_user_outlined,
            label: 'Privacy Policy',
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const SettingsSimpleMessageDialog(
                    title: 'Privacy Policy',
                    message:
                        'Privacy policy details will be added in next phase.',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 14),
          SettingsLegalRow(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const SettingsSimpleMessageDialog(
                    title: 'Terms of Service',
                    message:
                        'Terms of service details will be added in next phase.',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsLegalRow extends StatelessWidget {
  const SettingsLegalRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 34 / 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

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
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class SettingsPagePalette {
  const SettingsPagePalette._();

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color mutedText(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.secondary.withValues(alpha: _dark(context) ? 0.82 : 0.92);
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.22 : 0.12);
  }

  static Color fieldBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.14 : 0.06);
  }

  static Color rowBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.10 : 0.03);
  }

  static Color rowHighlightBackground(BuildContext context) {
    return Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.18 : 0.08);
  }
}
