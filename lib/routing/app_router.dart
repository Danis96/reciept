import 'package:flutter/material.dart';
import 'package:refyn/routing/routes.dart' as app_routes;
import 'package:refyn/routing/routing_generator.dart';

class AppRouter {
  const AppRouter._();

  static const String root = app_routes.root;
  static const String receiptDetails = app_routes.receiptDetails;

  static String receiptHeroTag(String source, String receiptId) =>
      app_routes.receiptHeroTag(source, receiptId);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) =>
      RouteGenerator.generateRoute(settings);
}
