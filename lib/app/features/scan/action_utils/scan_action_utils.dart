import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:reciep/app/features/history/controllers/history_controller.dart';
import 'package:reciep/app/features/scan/controllers/scan_controller.dart';

class ScanActionUtils {
  const ScanActionUtils._();

  static Future<void> onOpenGallery(BuildContext context) {
    return context.read<ScanController>().pickFromGallery();
  }

  static Future<void> onOpenCamera(BuildContext context) {
    return context.read<ScanController>().pickFromCamera();
  }

  static Future<void> onScan(BuildContext context) async {
    final ScanController scanController = context.read<ScanController>();
    final DashboardController dashboardController = context
        .read<DashboardController>();
    final HistoryController historyController = context
        .read<HistoryController>();

    await scanController.scanSelectedImage();
    await dashboardController.refreshHome();
    await historyController.loadHistory();
  }

  static void onReset(BuildContext context) {
    context.read<ScanController>().clearSelection();
  }

  static Future<void> onScanAnother(BuildContext context) {
    return context.read<ScanController>().showReadyToScan();
  }
}
