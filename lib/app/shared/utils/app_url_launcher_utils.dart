import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

const refynPrivacyPolicy = 'https://danispreldzic.netlify.app/privacy/refyn.html';

enum _UrlScheme { https, http, mailto, tel, unknown }

abstract final class AppUrlLauncherUtils {

  static Future<bool> launch(
      String url, {
        bool inApp = false,
        LaunchMode? mode,
      }) async {
    final uri = _parse(url);
    if (uri == null) {
      _log('Invalid URL: $url');
      return false;
    }
    return _launch(uri, inApp: inApp, mode: mode);
  }

  static Future<bool> launchWebUrl(
      String url, {
        bool inApp = false,
      }) =>
      launch(url, inApp: inApp);


  static Future<bool> launchEmail(String address) {
    final encoded = address.startsWith('mailto:') ? address : 'mailto:$address';
    return launch(encoded);
  }

  static Future<bool> launchPhone(String number) {
    final encoded = number.startsWith('tel:') ? number : 'tel:$number';
    return launch(encoded);
  }

  static Future<bool> canLaunch(String url) async {
    final uri = _parse(url);
    if (uri == null) return false;
    try {
      return await canLaunchUrl(uri);
    } catch (e) {
      _log('canLaunch check failed for $url: $e');
      return false;
    }
  }

  // ─── Internal helpers ───────────────────────────────────────────────────────

  static Future<bool> _launch(
      Uri uri, {
        bool inApp = false,
        LaunchMode? mode,
      }) async {
    final resolvedMode = mode ?? _resolveMode(uri, inApp: inApp);

    try {
      final canOpen = await canLaunchUrl(uri);
      if (!canOpen) {
        _log('No app available to handle: $uri');
        return false;
      }
      return await launchUrl(uri, mode: resolvedMode);
    } catch (e, st) {
      _log('Failed to launch $uri\n$e\n$st');
      return false;
    }
  }

  /// Chooses the best [LaunchMode] based on scheme and [inApp] flag.
  static LaunchMode _resolveMode(Uri uri, {required bool inApp}) {
    final scheme = _scheme(uri);
    switch (scheme) {
      case _UrlScheme.mailto:
      case _UrlScheme.tel:
        return LaunchMode.externalApplication;
      case _UrlScheme.https:
      case _UrlScheme.http:
        return inApp
            ? LaunchMode.inAppWebView
            : LaunchMode.externalApplication;
      case _UrlScheme.unknown:
        return LaunchMode.platformDefault;
    }
  }

  /// Safely parses [url] into a [Uri]; returns `null` if malformed.
  static Uri? _parse(String url) {
    if (url.trim().isEmpty) return null;
    try {
      final uri = Uri.parse(url.trim());
      // Must have a scheme to be launchable.
      return uri.hasScheme ? uri : null;
    } catch (_) {
      return null;
    }
  }

  static _UrlScheme _scheme(Uri uri) {
    return switch (uri.scheme.toLowerCase()) {
      'https' => _UrlScheme.https,
      'http' => _UrlScheme.http,
      'mailto' => _UrlScheme.mailto,
      'tel' => _UrlScheme.tel,
      _ => _UrlScheme.unknown,
    };
  }

  static void _log(String message) {
    if (kDebugMode) debugPrint('[AppUrlLauncherUtils] $message');
  }
}