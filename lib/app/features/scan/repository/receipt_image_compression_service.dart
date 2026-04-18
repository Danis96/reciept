import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class PreparedReceiptImage {
  const PreparedReceiptImage({
    required this.bytes,
    required this.mimeType,
  });

  final List<int> bytes;
  final String mimeType;
}

class ReceiptImageCompressionService {
  const ReceiptImageCompressionService({
    this.quality = 70,
    this.minWidth = 768,
    this.minHeight = 768,
  });

  final int quality;
  final int minWidth;
  final int minHeight;

  Future<PreparedReceiptImage> prepareForUpload({
    required String imagePath,
  }) async {
    final List<int>? compressedBytes = await FlutterImageCompress
        .compressWithFile(
          imagePath,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
          format: CompressFormat.jpeg,
        );

    if (compressedBytes != null && compressedBytes.isNotEmpty) {
      return PreparedReceiptImage(bytes: compressedBytes, mimeType: 'image/jpeg');
    }

    // only fall back to reading original if compression failed
    final List<int> originalBytes = await File(imagePath).readAsBytes();
    return PreparedReceiptImage(
      bytes: originalBytes,
      mimeType: _detectMimeType(imagePath),
    );
  }

  String _detectMimeType(String imagePath) {
    final String lower = imagePath.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lower.endsWith('.heic')) {
      return 'image/heic';
    }
    if (lower.endsWith('.heif')) {
      return 'image/heif';
    }
    return 'image/jpeg';
  }
}
