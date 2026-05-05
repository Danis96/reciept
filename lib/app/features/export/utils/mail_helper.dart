import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

enum MailSendResult { launched, launchedWithoutAttachments, unavailable }

class MailHelper {
  MailHelper._();

  static Future<MailSendResult> compose({
    List<String> to = const <String>[],
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
    String? fallbackBody,
    List<String> attachmentPaths = const <String>[],
    bool isHtml = false,
  }) async {
    final List<String> cleanedAttachmentPaths = attachmentPaths
        .where((String path) => path.trim().isNotEmpty)
        .toList(growable: false);
    final bool requestedAttachments = cleanedAttachmentPaths.isNotEmpty;

    final bool launched = await _send(
      to: to,
      cc: cc,
      bcc: bcc,
      subject: subject,
      body: body,
      fallbackBody: fallbackBody,
      attachmentPaths: cleanedAttachmentPaths,
      isHtml: isHtml,
    );

    if (!launched) {
      return MailSendResult.unavailable;
    }

    if (requestedAttachments && !_supportsComposerAttachments) {
      return MailSendResult.launchedWithoutAttachments;
    }

    return MailSendResult.launched;
  }

  static Future<bool> _send({
    List<String> to = const <String>[],
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
    String? fallbackBody,
    List<String> attachmentPaths = const <String>[],
    bool isHtml = false,
  }) async {
    if (_supportsComposerAttachments && attachmentPaths.isNotEmpty) {
      try {
        await FlutterEmailSender.send(
          Email(
            recipients: to,
            cc: cc ?? const <String>[],
            bcc: bcc ?? const <String>[],
            subject: subject ?? '',
            body: body ?? '',
            attachmentPaths: attachmentPaths,
            isHTML: isHtml,
          ),
        );
        return true;
      } catch (_) {}
    }

    return _launchMailto(
      to: to,
      cc: cc,
      bcc: bcc,
      subject: subject,
      body: fallbackBody ?? body,
    );
  }

  static Future<bool> _launchMailto({
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
  }) async {
    final Map<String, String> params = <String, String>{};

    if (cc != null && cc.isNotEmpty) {
      params['cc'] = cc.join(',');
    }
    if (bcc != null && bcc.isNotEmpty) {
      params['bcc'] = bcc.join(',');
    }
    if (subject != null && subject.isNotEmpty) {
      params['subject'] = subject;
    }
    if (body != null && body.isNotEmpty) {
      params['body'] = body;
    }

    final Uri uri = Uri(
      scheme: 'mailto',
      path: to.join(','),
      query: _encodeQueryParameters(params),
    );

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static bool get _supportsComposerAttachments =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static String? _encodeQueryParameters(Map<String, String> params) {
    if (params.isEmpty) {
      return null;
    }

    return params.entries
        .map(
          (MapEntry<String, String> entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }
}
