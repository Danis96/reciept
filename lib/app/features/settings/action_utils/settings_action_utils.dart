import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:refyn/app/features/export/repository/receipt_export_service.dart';
import 'package:refyn/app/features/export/utils/mail_helper.dart';
import 'package:refyn/app/features/export/utils/receipt_report_email_builder.dart';
import 'package:refyn/app/features/export/utils/share_file_helper.dart';
import 'package:refyn/app/features/history/controllers/history_controller.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/app/features/scan/controllers/scan_controller.dart';
import 'package:refyn/app/features/settings/controllers/settings_controller.dart';
import 'package:refyn/app/helpers/extensions/build_context_x.dart';
import 'package:refyn/app/features/settings/ui/widgets/shared/settings_simple_message_dialog.dart';
import 'package:refyn/app/shared/utils/app_url_launcher_utils.dart';
import 'package:refyn/l10n/app_localizations.dart';

class SettingsActionUtils {
  const SettingsActionUtils._();

  static Future<void> onThemeModeChanged(
    BuildContext context,
    ThemeMode themeMode,
  ) {
    return context.read<SettingsController>().updateThemeMode(themeMode);
  }

  static Future<void> onLanguageChanged(BuildContext context, Locale locale) {
    return context.read<SettingsController>().updateLanguage(locale);
  }

  static Future<void> onCurrencyChanged(
    BuildContext context,
    String code,
  ) async {
    await context.read<SettingsController>().updateCurrency(code);
    if (!context.mounted) {
      return;
    }
    await _reloadAppState(context);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.currencySavedLabel(code.toUpperCase()))),
    );
  }

  static Future<void> confirmApiKey(BuildContext context) async {
    final SettingsController controller = context.read<SettingsController>();
    try {
      await controller.confirmApiKey();
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.aiConfigurationFailed,
        message: _buildAiConfigurationErrorMessage(error),
      );
    }
  }

  static Future<void> resetAiConfiguration(BuildContext context) {
    return context.read<SettingsController>().resetAiConfiguration();
  }

  static Future<void> saveSelectedAiModel(
    BuildContext context,
    String modelId,
  ) {
    return context.read<SettingsController>().saveSelectedModel(modelId);
  }

  static Future<void> saveAiThinkingEnabled(
    BuildContext context,
    bool enabled,
  ) {
    return context.read<SettingsController>().saveThinkingEnabled(enabled);
  }

  static String _buildAiConfigurationErrorMessage(Object error) {
    final String details = _normalizeErrorMessage(error);
    if (details == 'missing_api_key') {
      return AppLocalizations.current.addApiKeyBeforeConfirming;
    }
    return details.isEmpty
        ? AppLocalizations.current.aiConfigurationConfirmFailed
        : details;
  }

  static Future<void> exportBackup(BuildContext context) async {
    try {
      final result = await context.read<SettingsController>().exportBackup();
      if (!context.mounted) {
        return;
      }
      await ShareFileHelper.shareFile(
        context: context,
        filePath: result.archivePath,
        text:
            'Receipt local backup\nReceipts: ${result.receiptCount}\nAttachments: ${result.attachmentCount}',
        subject: 'Receipt backup',
        mimeType: 'application/zip',
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.backupReadyLabel(
              result.receiptCount,
              result.attachmentCount,
            ),
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.backupFailed,
        message: _normalizeErrorMessage(error),
      );
    }
  }

  static Future<void> exportReceipts(
    BuildContext context,
    ReceiptExportFormat format,
  ) async {
    try {
      final String filePath = await context
          .read<SettingsController>()
          .exportReceipts(format);
      if (!context.mounted) {
        return;
      }

      final ({String label, String mimeType}) meta = switch (format) {
        ReceiptExportFormat.csv => (label: 'CSV', mimeType: 'text/csv'),
        ReceiptExportFormat.json => (
          label: 'JSON',
          mimeType: 'application/json',
        ),
        ReceiptExportFormat.pdf => (label: 'PDF', mimeType: 'application/pdf'),
      };

      await ShareFileHelper.shareFile(
        context: context,
        filePath: filePath,
        text: 'Receipt export ready (${meta.label}).',
        subject: 'Receipt export ${meta.label}',
        mimeType: meta.mimeType,
      );
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(context.l10n.exportReadyLabel(meta.label))),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.exportFailed,
        message: _normalizeErrorMessage(error),
      );
    }
  }

  static Future<void> emailReceipts(BuildContext context) async {
    try {
      final List<ReceiptModel> receipts = await context
          .read<SettingsController>()
          .getReceiptsForExport();
      final ReceiptReportEmailDraft draft = ReceiptReportEmailBuilder.build(
        receipts,
      );
      final MailSendResult result = await MailHelper.compose(
        subject: draft.subject,
        body: draft.htmlBody,
        fallbackBody: draft.plainTextBody,
        attachmentPaths: draft.attachmentPaths,
        isHtml: true,
      );

      if (!context.mounted) {
        return;
      }

      switch (result) {
        case MailSendResult.launched:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.mailAppOpenedWithExport),
            ),
          );
          break;
        case MailSendResult.launchedWithoutAttachments:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.mailAppOpenedManualAttachments,
              ),
            ),
          );
          break;
        case MailSendResult.unavailable:
          await _showGenericErrorDialog(
            context,
            title: context.l10n.emailUnavailable,
            message: context.l10n.noMailAppAvailable,
          );
          break;
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.emailExportFailed,
        message: _normalizeErrorMessage(error),
      );
    }
  }

  static Future<void> importBackup(BuildContext context) async {
    final FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['zip'],
      withData: false,
    );
    final String? archivePath = picked?.files.single.path;
    if (archivePath == null || archivePath.trim().isEmpty) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    final bool confirmed = await _showConfirmationDialog(
      context,
      title: context.l10n.importBackupQuestion,
      message: context.l10n.importBackupWarning,
      confirmLabel: context.l10n.importBackup,
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      final result = await context.read<SettingsController>().importBackup(
        archivePath,
      );
      if (!context.mounted) {
        return;
      }
      await _reloadAppState(context);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.backupRestoredLabel(
              result.receiptCount,
              result.attachmentCount,
            ),
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.restoreFailed,
        message: _normalizeErrorMessage(error),
      );
    }
  }

  static Future<void> clearAllLocalData(BuildContext context) async {
    final bool confirmed = await _showConfirmationDialog(
      context,
      title: context.l10n.clearLocalDataQuestion,
      message: context.l10n.clearLocalDataWarning,
      confirmLabel: context.l10n.clear,
      destructive: true,
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await context.read<SettingsController>().clearAllLocalData();
      if (!context.mounted) {
        return;
      }
      await _reloadAppState(context);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.localDataCleared)));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showGenericErrorDialog(
        context,
        title: context.l10n.clearFailed,
        message: _normalizeErrorMessage(error),
      );
    }
  }

  static Future<void> showPrivacyPolicy(BuildContext context) async {
    await AppUrlLauncherUtils.launch(refynPrivacyPolicy);
  }

  static Future<void> _reloadAppState(BuildContext context) async {
    final DashboardController dashboardController = context
        .read<DashboardController>();
    final HistoryController historyController = context
        .read<HistoryController>();
    final ScanController scanController = context.read<ScanController>();

    await dashboardController.refreshHome();
    await historyController.loadHistory();
    await scanController.initialize();
  }

  static Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD92D00),
                    )
                  : null,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<void> _showGenericErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.close),
            ),
          ],
        );
      },
    );
  }

  static String _normalizeErrorMessage(Object error) {
    final String raw = error.toString().trim();
    if (raw.startsWith('Bad state: ')) {
      return raw.substring('Bad state: '.length).trim();
    }
    return raw.isEmpty ? AppLocalizations.current.unknownError : raw;
  }
}
