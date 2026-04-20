import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciep/app/features/scan/ui/widgets/premium_scan_loading_panel.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/theme/app_colors.dart';
import 'package:reciep/theme/app_spacing.dart';

enum ScanSurfaceState { idle, imageSelected, loading, success, error }

class ScanSurfaceCard extends StatelessWidget {
  const ScanSurfaceCard({
    super.key,
    required this.state,
    this.imagePath,
    this.loadingStep = 0,
    this.errorMessage,
    this.result,
    this.hasDraft = false,
    this.lowConfidence = false,
    this.savingDraft = false,
    required this.onGallery,
    required this.onCamera,
    required this.onScan,
    required this.onRetry,
    required this.onReset,
    required this.onScanAnother,
    required this.onEditDraft,
    required this.onSaveDraft,
    required this.scanButtonText,
    required this.retryLabel,
    required this.pickAnotherImageLabel,
    required this.resetLabel,
    required this.scanAnotherLabel,
    required this.saveReceiptLabel,
    required this.editBeforeSaveLabel,
    required this.savingLabel,
    required this.lowConfidenceWarningLabel,
    required this.successTitle,
    required this.errorTitle,
    required this.errorFallback,
    required this.loadingSteps,
    required this.merchantLabel,
    required this.totalLabel,
    required this.dateLabel,
    required this.categoryLabel,
    required this.itemsLabel,
    required this.confidenceLabel,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.cameraTitle,
    required this.cameraSubtitle,
    required this.supportFormatsText,
  });

  final ScanSurfaceState state;
  final String? imagePath;
  final int loadingStep;
  final String? errorMessage;
  final ReceiptModel? result;
  final bool hasDraft;
  final bool lowConfidence;
  final bool savingDraft;
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final VoidCallback onScan;
  final VoidCallback onRetry;
  final VoidCallback onReset;
  final VoidCallback onScanAnother;
  final VoidCallback onEditDraft;
  final VoidCallback onSaveDraft;
  final String scanButtonText;
  final String retryLabel;
  final String pickAnotherImageLabel;
  final String resetLabel;
  final String scanAnotherLabel;
  final String saveReceiptLabel;
  final String editBeforeSaveLabel;
  final String savingLabel;
  final String lowConfidenceWarningLabel;
  final String successTitle;
  final String errorTitle;
  final String errorFallback;
  final List<String> loadingSteps;
  final String merchantLabel;
  final String totalLabel;
  final String dateLabel;
  final String categoryLabel;
  final String itemsLabel;
  final String confidenceLabel;
  final String uploadTitle;
  final String uploadSubtitle;
  final String cameraTitle;
  final String cameraSubtitle;
  final String supportFormatsText;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final Animation<Offset> slide = Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (state) {
      case ScanSurfaceState.idle:
        return _IdleView(
          key: const ValueKey(ScanSurfaceState.idle),
          onGallery: onGallery,
          onCamera: onCamera,
          uploadTitle: uploadTitle,
          uploadSubtitle: uploadSubtitle,
          cameraTitle: cameraTitle,
          cameraSubtitle: cameraSubtitle,
          supportFormatsText: supportFormatsText,
        );
      case ScanSurfaceState.imageSelected:
        return _ImageSelectedView(
          key: ValueKey(imagePath),
          imagePath: imagePath,
          onScan: onScan,
          onReset: onReset,
          scanButtonText: scanButtonText,
          resetLabel: resetLabel,
        );
      case ScanSurfaceState.loading:
        return _LoadingView(
          key: const ValueKey(ScanSurfaceState.loading),
          imagePath: imagePath,
          loadingStep: loadingStep,
          steps: loadingSteps,
        );
      case ScanSurfaceState.success:
        return _SuccessView(
          key: ValueKey(result?.id),
          result: result,
          title: successTitle,
          hasDraft: hasDraft,
          lowConfidence: lowConfidence,
          lowConfidenceWarningLabel: lowConfidenceWarningLabel,
          savingDraft: savingDraft,
          savingLabel: savingLabel,
          saveReceiptLabel: saveReceiptLabel,
          editBeforeSaveLabel: editBeforeSaveLabel,
          onScanAnother: onScanAnother,
          onEditDraft: onEditDraft,
          onSaveDraft: onSaveDraft,
          scanAnotherLabel: scanAnotherLabel,
          merchantLabel: merchantLabel,
          totalLabel: totalLabel,
          dateLabel: dateLabel,
          categoryLabel: categoryLabel,
          itemsLabel: itemsLabel,
          confidenceLabel: confidenceLabel,
        );
      case ScanSurfaceState.error:
        return _ErrorView(
          key: const ValueKey(ScanSurfaceState.error),
          title: errorTitle,
          message: errorMessage ?? errorFallback,
          onRetry: onRetry,
          retryLabel: retryLabel,
          onReset: onReset,
          resetLabel: pickAnotherImageLabel,
        );
    }
  }
}

// --- View Widgets ---

class _IdleView extends StatelessWidget {
  const _IdleView({
    super.key,
    required this.onGallery,
    required this.onCamera,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.cameraTitle,
    required this.cameraSubtitle,
    required this.supportFormatsText,
  });

  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final String uploadTitle;
  final String uploadSubtitle;
  final String cameraTitle;
  final String cameraSubtitle;
  final String supportFormatsText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          onTap: onGallery,
          child: CustomPaint(
            painter: _DashedRoundedBorderPainter(
              color: colorScheme.secondary.withValues(alpha: 0.45),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  const _UploadDecorCircle(
                    alignment: Alignment.bottomLeft,
                    size: 108,
                    offset: Offset(-30, 28),
                  ),
                  const _UploadDecorCircle(
                    alignment: Alignment.topRight,
                    size: 108,
                    offset: Offset(30, -28),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 22,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withValues(alpha:0.16),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.upload_outlined, size: 34),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            uploadTitle,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            uploadSubtitle,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: onCamera,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border:
              Border.all(color: colorScheme.secondary.withValues(alpha:0.26)),
            ),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha:0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.camera_alt_outlined),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cameraTitle,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cameraSubtitle,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.arrow_forward, color: colorScheme.secondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            supportFormatsText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageSelectedView extends StatelessWidget {
  const _ImageSelectedView({
    super.key,
    required this.imagePath,
    required this.onScan,
    required this.onReset,
    required this.scanButtonText,
    required this.resetLabel,
  });

  final String? imagePath;
  final VoidCallback onScan;
  final VoidCallback onReset;
  final String scanButtonText;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return const SizedBox.shrink();
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: onScan,
                    child: Text(scanButtonText),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(onPressed: onReset, child: Text(resetLabel)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({
    super.key,
    required this.imagePath,
    required this.loadingStep,
    required this.steps,
  });

  final String? imagePath;
  final int loadingStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PremiumScanLoadingPanel(
          imagePath: imagePath,
          loadingStep: loadingStep,
          steps: steps,
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    super.key,
    required this.result,
    required this.title,
    required this.hasDraft,
    required this.lowConfidence,
    required this.lowConfidenceWarningLabel,
    required this.savingDraft,
    required this.savingLabel,
    required this.saveReceiptLabel,
    required this.editBeforeSaveLabel,
    required this.onScanAnother,
    required this.onEditDraft,
    required this.onSaveDraft,
    required this.scanAnotherLabel,
    required this.merchantLabel,
    required this.totalLabel,
    required this.dateLabel,
    required this.categoryLabel,
    required this.itemsLabel,
    required this.confidenceLabel,
  });

  final ReceiptModel? result;
  final String title;
  final bool hasDraft;
  final bool lowConfidence;
  final String lowConfidenceWarningLabel;
  final bool savingDraft;
  final String savingLabel;
  final String saveReceiptLabel;
  final String editBeforeSaveLabel;
  final VoidCallback onScanAnother;
  final VoidCallback onEditDraft;
  final VoidCallback onSaveDraft;
  final String scanAnotherLabel;
  final String merchantLabel;
  final String totalLabel;
  final String dateLabel;
  final String categoryLabel;
  final String itemsLabel;
  final String confidenceLabel;

  @override
  Widget build(BuildContext context) {
    final ReceiptModel? receipt = result;
    if (receipt == null) {
      return const SizedBox.shrink();
    }

    final DateFormat dateFormat = DateFormat('M/d/yyyy');
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color successColor = AppColors.success;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: successColor.withValues(alpha:0.55), width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: successColor),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: successColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          if (lowConfidence) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.secondary.withValues(alpha:0.5)),
              ),
              child: Text(
                lowConfidenceWarningLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _ScanSuccessRow(label: merchantLabel, value: receipt.merchant.name),
          _ScanSuccessRow(
              label: totalLabel,
              value:
              '${receipt.totals.total.toStringAsFixed(2)} KM'),
          _ScanSuccessRow(
              label: dateLabel, value: dateFormat.format(receipt.createdAt)),
          _ScanSuccessRow(label: itemsLabel, value: '${receipt.items.length}'),
          _ScanSuccessRow(
              label: confidenceLabel,
              value: '${(receipt.confidence * 100).round()}%'),
          const SizedBox(height: AppSpacing.md),
          if (hasDraft)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: savingDraft ? null : onSaveDraft,
                    child: Text(savingDraft ? savingLabel : saveReceiptLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: savingDraft ? null : onEditDraft,
                    child: Text('Edit'),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onScanAnother,
              child: Text(scanAnotherLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    required this.retryLabel,
    required this.onReset,
    required this.resetLabel,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  final VoidCallback onReset;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color errorColor = colorScheme.error;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: errorColor.withValues(alpha:0.55), width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: errorColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: errorColor, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(message),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(onPressed: onReset, child: Text(resetLabel)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _ScanSuccessRow extends StatelessWidget {
  const _ScanSuccessRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium!.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadDecorCircle extends StatelessWidget {
  const _UploadDecorCircle({
    required this.alignment,
    required this.size,
    this.offset = Offset.zero,
  });

  final Alignment alignment;
  final double size;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha:0.08),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 18;
    const double dashWidth = 7;
    const double dashSpace = 5;
    const double strokeWidth = 1.3;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final double end = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
