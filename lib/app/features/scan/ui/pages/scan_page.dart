import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/scan/action_utils/scan_action_utils.dart';
import 'package:reciep/app/features/scan/controllers/scan_controller.dart';
import 'package:reciep/app/features/scan/controllers/scan_view_state.dart';
import 'package:reciep/app/features/scan/repository/scan_failure.dart';
import 'package:reciep/app/features/scan/ui/widgets/recent_scans_section.dart';
import 'package:reciep/app/features/scan/ui/widgets/scan_header_section.dart';
import 'package:reciep/app/features/scan/ui/widgets/scan_surface_card.dart';
import 'package:reciep/app/helpers/extensions/build_context_x.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_spacing.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  int _handledFailureEventId = 0;

  @override
  Widget build(BuildContext context) {
    return Selector<ScanController, _FailureSignal>(
      selector: (_, ScanController controller) => _FailureSignal(
        eventId: controller.failureEventId,
        failure: controller.failure,
      ),
      builder: (BuildContext context, _FailureSignal signal, Widget? _) {
        _handleFailurePopup(signal);
        return const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ScanHeaderSection(),
                SizedBox(height: AppSpacing.md),
                _ScanSurfaceSection(),
                SizedBox(height: AppSpacing.lg),
                _RecentScanSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFailurePopup(_FailureSignal signal) {
    final ScanFailure? failure = signal.failure;
    if (failure == null || signal.eventId == _handledFailureEventId) {
      return;
    }
    _handledFailureEventId = signal.eventId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ScanActionUtils.showErrorPopup(context, failure);
    });
  }
}

class _ScanHeaderSection extends StatelessWidget {
  const _ScanHeaderSection();

  @override
  Widget build(BuildContext context) {
    return ScanHeaderSection(
      title: context.l10n.scanReceiptTitle,
      subtitle: context.l10n.scanReceiptSubtitle,
    );
  }
}

class _ScanSurfaceSection extends StatelessWidget {
  const _ScanSurfaceSection();

  @override
  Widget build(BuildContext context) {
    return Selector<ScanController, _ScanSurfaceViewData>(
      selector: (_, ScanController controller) => _ScanSurfaceViewData(
        state: controller.state,
        imagePath: controller.selectedImagePath,
        loadingStep: controller.loadingStep,
        errorMessage: controller.errorMessage,
        result: controller.lastScannedReceipt,
        hasDraft: controller.hasPendingReceiptDraft,
        lowConfidence: controller.isLowConfidence,
        savingDraft: controller.savingDraft,
      ),
      shouldRebuild:
          (_ScanSurfaceViewData previous, _ScanSurfaceViewData next) =>
              previous != next,
      builder:
          (BuildContext context, _ScanSurfaceViewData data, Widget? child) =>
              ScanSurfaceCard(
                state: ScanSurfaceStateMapper(data.state).value,
                imagePath: data.imagePath,
                loadingStep: data.loadingStep,
                errorMessage: data.errorMessage,
                result: data.result,
                hasDraft: data.hasDraft,
                lowConfidence: data.lowConfidence,
                savingDraft: data.savingDraft,
                onGallery: () => ScanActionUtils.onOpenGallery(context),
                onCamera: () => ScanActionUtils.onOpenCamera(context),
                onScan: () => ScanActionUtils.onScan(context),
                onRetry: () => ScanActionUtils.onRetryScan(context),
                onReset: () => ScanActionUtils.onReset(context),
                onScanAnother: () => ScanActionUtils.onScanAnother(context),
                onEditDraft: () => ScanActionUtils.onEditDraft(context),
                onSaveDraft: () => ScanActionUtils.onSaveDraft(context),
                scanButtonText: context.l10n.scanReceiptButton,
                retryLabel: context.l10n.scanRetry,
                pickAnotherImageLabel: context.l10n.scanPickAnotherImage,
                resetLabel: context.l10n.scanReset,
                scanAnotherLabel: context.l10n.scanAnother,
                saveReceiptLabel: context.l10n.scanSaveReceipt,
                editBeforeSaveLabel: context.l10n.scanEditBeforeSave,
                savingLabel: context.l10n.scanSaving,
                lowConfidenceWarningLabel:
                    context.l10n.scanLowConfidenceWarning,
                successTitle: context.l10n.scanSuccessTitle,
                errorTitle: context.l10n.scanErrorTitle,
                errorFallback: context.l10n.scanErrorFallback,
                merchantLabel: context.l10n.scanMerchant,
                totalLabel: context.l10n.scanTotal,
                dateLabel: context.l10n.scanDate,
                categoryLabel: context.l10n.scanCategory,
                itemsLabel: context.l10n.scanItems,
                confidenceLabel: context.l10n.scanConfidence,
                uploadTitle: context.l10n.scanUploadTitle,
                uploadSubtitle: context.l10n.scanUploadSubtitle,
                cameraTitle: context.l10n.scanCameraTitle,
                cameraSubtitle: context.l10n.scanCameraSubtitle,
                supportFormatsText: context.l10n.scanSupportFormats,
                loadingSteps: <String>[
                  context.l10n.scanStepUploading,
                  context.l10n.scanStepReading,
                  context.l10n.scanStepDetecting,
                  context.l10n.scanStepCategorizing,
                  context.l10n.scanStepFinalizing,
                ],
              ),
    );
  }
}

class _RecentScanSection extends StatelessWidget {
  const _RecentScanSection();

  @override
  Widget build(BuildContext context) {
    return Selector<ScanController, List<ReceiptModel>>(
      selector: (_, ScanController controller) => controller.recentReceipts,
      builder:
          (BuildContext context, List<ReceiptModel> receipts, Widget? child) =>
              RecentScansSection(
                title: context.l10n.scanRecentTitle,
                emptyText: context.l10n.noReceiptsYet,
                emptyHintText: context.l10n.scanRecentEmptyHint,
                receipts: receipts,
              ),
    );
  }
}

class _FailureSignal {
  const _FailureSignal({required this.eventId, required this.failure});

  final int eventId;
  final ScanFailure? failure;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _FailureSignal &&
        other.eventId == eventId &&
        other.failure == failure;
  }

  @override
  int get hashCode => Object.hash(eventId, failure);
}

class _ScanSurfaceViewData {
  const _ScanSurfaceViewData({
    required this.state,
    required this.imagePath,
    required this.loadingStep,
    required this.errorMessage,
    required this.result,
    required this.hasDraft,
    required this.lowConfidence,
    required this.savingDraft,
  });

  final ScanViewState state;
  final String? imagePath;
  final int loadingStep;
  final String? errorMessage;
  final ReceiptModel? result;
  final bool hasDraft;
  final bool lowConfidence;
  final bool savingDraft;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _ScanSurfaceViewData &&
        other.state == state &&
        other.imagePath == imagePath &&
        other.loadingStep == loadingStep &&
        other.errorMessage == errorMessage &&
        other.result == result &&
        other.hasDraft == hasDraft &&
        other.lowConfidence == lowConfidence &&
        other.savingDraft == savingDraft;
  }

  @override
  int get hashCode => Object.hash(
    state,
    imagePath,
    loadingStep,
    errorMessage,
    result,
    hasDraft,
    lowConfidence,
    savingDraft,
  );
}

class ScanSurfaceStateMapper {
  ScanSurfaceStateMapper(this.state);

  final ScanViewState state;

  ScanSurfaceState get value {
    switch (state) {
      case ScanViewState.idle:
        return ScanSurfaceState.idle;
      case ScanViewState.imageSelected:
        return ScanSurfaceState.imageSelected;
      case ScanViewState.loading:
        return ScanSurfaceState.loading;
      case ScanViewState.success:
        return ScanSurfaceState.success;
      case ScanViewState.error:
        return ScanSurfaceState.error;
    }
  }
}
