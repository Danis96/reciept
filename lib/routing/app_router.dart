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
        return _buildTransitionRoute(
          settings: settings,
          builder: (BuildContext context) {
            return ChangeNotifierProvider<ReceiptDetailsController>(
              create: (BuildContext context) => ReceiptDetailsController(
                repository: context.read<ReceiptDetailsRepository>(),
                receiptId: args.receiptId,
              )..load(),
              child: const ReceiptDetailsPage(),
            );
          },
        );
      case root:
      default:
        return _buildTransitionRoute(
          settings: settings,
          builder: (_) => const DashboardShellPage(),
        );
    }
  }

  static PageRouteBuilder<void> _buildTransitionRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => builder(context),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<Offset> slide =
                Tween<Offset>(
                  begin: const Offset(0, 0.015),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(position: slide, child: child),
            );
          },
    );
  }
}

class ReceiptDetailsRouteArgs {
  const ReceiptDetailsRouteArgs({required this.receiptId});

  final String receiptId;
}
