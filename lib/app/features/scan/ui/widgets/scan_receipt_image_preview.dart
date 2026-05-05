import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wiggly_loaders/wiggly_loaders.dart';

class ScanReceiptImagePreview extends StatelessWidget {
  const ScanReceiptImagePreview({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
  });

  final String? imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return Container(
        color: const Color(0xFFDDDEE5),
        child: const Center(child: Icon(Icons.receipt_long_rounded, size: 72)),
      );
    }

    return Image.file(
      File(imagePath!),
      fit: fit,
      frameBuilder:
          (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(color: const Color(0xFFDDDEE5)),
                const Center(
                  child: WigglyLoader.indeterminate(size: 32, strokeWidth: 2.2),
                ),
              ],
            );
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: const Color(0xFFDDDEE5),
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 44),
              ),
            );
          },
    );
  }
}
