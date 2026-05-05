import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:refyn/app/features/receipt_details/repository/receipt_details_repository.dart';
import 'package:refyn/app/features/receipt_details/ui/pages/receipt_details_page.dart';
import 'package:refyn/app/widgets/android_startup_splash_gate.dart';

import '../app/features/dashboard/ui/pages/dashboard_shell_page.dart';

class AppRouter {
  const AppRouter._();

  static const String root = '/';
  static const String receiptDetails = '/receipt-details';

  static String receiptHeroTag(String source, String receiptId) =>
      'receipt-hero-$source-$receiptId';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case receiptDetails:
        final ReceiptDetailsRouteArgs args =
            settings.arguments! as ReceiptDetailsRouteArgs;
        return _buildTransitionRoute(
          settings: settings,
          receiptDetailsStyle: true,
          builder: (BuildContext context) {
            return ChangeNotifierProvider<ReceiptDetailsController>(
              create: (BuildContext context) => ReceiptDetailsController(
                repository: context.read<ReceiptDetailsRepository>(),
                receiptId: args.receiptId,
              )..load(),
              child: ReceiptDetailsPage(heroTag: args.heroTag),
            );
          },
        );
      case root:
      default:
        return _buildTransitionRoute(
          settings: settings,
          builder: (_) => const AndroidStartupSplashGate(
            child: DashboardShellPage(),
          ),
        );
    }
  }

  static PageRouteBuilder<void> _buildTransitionRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
    bool receiptDetailsStyle = false,
  }) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: Duration(
        milliseconds: receiptDetailsStyle ? 420 : 260,
      ),
      reverseTransitionDuration: Duration(
        milliseconds: receiptDetailsStyle ? 320 : 220,
      ),
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
            final CurvedAnimation curved = CurvedAnimation(
              parent: animation,
              curve: receiptDetailsStyle
                  ? Curves.easeOutQuart
                  : Curves.easeOutCubic,
            );
            final Animation<Offset> slide = Tween<Offset>(
              begin: Offset(0, receiptDetailsStyle ? 0.04 : 0.015),
              end: Offset.zero,
            ).animate(curved);
            final Animation<double> scale = Tween<double>(
              begin: receiptDetailsStyle ? 0.985 : 1,
              end: 1,
            ).animate(curved);
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(scale: scale, child: child),
              ),
            );
          },
    );
  }
}

class ReceiptDetailsRouteArgs {
  const ReceiptDetailsRouteArgs({
    required this.receiptId,
    required this.heroTag,
  });

  final String receiptId;
  final String heroTag;
}
