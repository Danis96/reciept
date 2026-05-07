import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refyn/app/features/introduction/ui/pages/introduction_flow_page.dart';
import 'package:refyn/app/features/receipt_details/controllers/receipt_details_controller.dart';
import 'package:refyn/app/features/receipt_details/repository/receipt_details_repository.dart';
import 'package:refyn/app/features/receipt_details/ui/pages/receipt_details_page.dart';
import 'package:refyn/routing/route_arguments.dart';
import 'package:refyn/routing/routes.dart';

mixin RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case receiptDetails:
        final ReceiptDetailsPageArguments args =
            settings.arguments! as ReceiptDetailsPageArguments;
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
          builder: (_) => const IntroductionFlowPage(),
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
