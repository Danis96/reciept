import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/scan/action_utils/scan_action_utils.dart';
import 'package:reciep/app/features/scan/controllers/scan_controller.dart';
import 'package:reciep/app/features/scan/controllers/scan_view_state.dart';
import 'package:reciep/app/features/scan/ui/widgets/recent_scans_section.dart';
import 'package:reciep/app/features/scan/ui/widgets/scan_header_section.dart';
import 'package:reciep/app/features/scan/ui/widgets/scan_surface_card.dart';
import 'package:reciep/app/helpers/extensions/build_context_x.dart';
import 'package:reciep/theme/app_spacing.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanController>(
      builder: (BuildContext context, ScanController controller, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScanHeaderSection(
                  title: context.l10n.scanReceiptTitle,
                  subtitle: context.l10n.scanReceiptSubtitle,
                ),
                const SizedBox(height: AppSpacing.md),
                ScanSurfaceCard(
                  state: ScanSurfaceStateMapper(controller.state).value,
                  imagePath: controller.selectedImagePath,
                  loadingStep: controller.loadingStep,
                  errorMessage: controller.errorMessage,
                  result: controller.lastScannedReceipt,
                  onGallery: () => ScanActionUtils.onOpenGallery(context),
                  onCamera: () => ScanActionUtils.onOpenCamera(context),
                  onScan: () => ScanActionUtils.onScan(context),
                  onReset: () => ScanActionUtils.onReset(context),
                  onScanAnother: () => ScanActionUtils.onScanAnother(context),
                  scanButtonText: context.l10n.scanReceiptButton,
                  resetLabel: context.l10n.scanReset,
                  scanAnotherLabel: context.l10n.scanAnother,
                  successTitle: context.l10n.scanSuccessTitle,
                  errorTitle: context.l10n.scanErrorTitle,
                  errorFallback: context.l10n.scanErrorFallback,
                  viewDetailsLabel: context.l10n.scanViewDetails,
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
                    'Uploading image',
                    'Reading receipt',
                    'Extracting data',
                    'Structuring JSON',
                    'Saving receipt',
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                RecentScansSection(
                  title: context.l10n.scanRecentTitle,
                  emptyText: context.l10n.noReceiptsYet,
                  receipts: controller.recentReceipts,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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
