import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reciep/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:reciep/app/features/receipt_details/repository/receipt_details_repository.dart';
import 'package:reciep/app/features/receipt_details/ui/pages/receipt_details_page.dart';

import '../app/features/dashboard/ui/pages/dashboard_shell_page.dart';

class AppRouter {
  const AppRouter._();

  static const String root = '/';
  static const String receiptDetails = '/receipt-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case receiptDetails:
        final ReceiptDetailsRouteArgs args =
            settings.arguments! as ReceiptDetailsRouteArgs;
        return MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ChangeNotifierProvider<ReceiptDetailsController>(
              create: (BuildContext context) => ReceiptDetailsController(
                repository: context.read<ReceiptDetailsRepository>(),
                receiptId: args.receiptId,
              )..load(),
              child: const ReceiptDetailsPage(),
            );
          },
          settings: settings,
        );
      case root:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardShellPage(),
          settings: settings,
        );
    }
  }
}

class ReceiptDetailsRouteArgs {
  const ReceiptDetailsRouteArgs({required this.receiptId});

  final String receiptId;
}
