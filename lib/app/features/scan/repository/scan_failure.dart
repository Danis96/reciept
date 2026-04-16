enum ScanFailureType {
  imageUploadFailed,
  aiResponseFailed,
  invalidJson,
  parseFailure,
}

class ScanFailure {
  const ScanFailure({
    required this.type,
    required this.title,
    required this.message,
    this.technicalDetails,
  });

  final ScanFailureType type;
  final String title;
  final String message;
  final String? technicalDetails;
}

class ScanException implements Exception {
  const ScanException(this.failure);

  final ScanFailure failure;

  @override
  String toString() => failure.message;
}
