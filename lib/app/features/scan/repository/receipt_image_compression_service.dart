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
    this.quality = 75,
    this.minWidth = 1024,
    this.minHeight = 1024,
  });

  final int quality;
  final int minWidth;
  final int minHeight;

  Future<PreparedReceiptImage> prepareForUpload({
    required String imagePath,
  }) async {
    final File imageFile = File(imagePath);
    final List<int> originalBytes = await imageFile.readAsBytes();

    final List<int>? compressedBytes = await FlutterImageCompress
        .compressWithFile(
          imagePath,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
          format: CompressFormat.jpeg,
        );

    return PreparedReceiptImage(
      bytes: compressedBytes == null || compressedBytes.isEmpty
          ? originalBytes
          : compressedBytes,
      mimeType: compressedBytes == null || compressedBytes.isEmpty
          ? _detectMimeType(imagePath)
          : 'image/jpeg',
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
