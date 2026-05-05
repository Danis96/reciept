import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

class ShareFileHelper {
  const ShareFileHelper._();

  static Future<void> shareFile({
    required BuildContext context,
    required String filePath,
    String? text,
    String? subject,
    String? mimeType,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(filePath, mimeType: mimeType)],
        text: text,
        subject: subject,
        sharePositionOrigin: _shareOrigin(context),
      ),
    );
  }

  static Rect _shareOrigin(BuildContext context) {
    final Object? box = context.findRenderObject();
    if (box is RenderBox && box.hasSize) {
      return box.localToGlobal(Offset.zero) & box.size;
    }

    final Size size = MediaQuery.sizeOf(context);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 1,
      height: 1,
    );
  }
}
