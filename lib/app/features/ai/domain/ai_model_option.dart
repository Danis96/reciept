class AiModelOption {
  const AiModelOption({
    required this.id,
    required this.label,
    required this.supportedGenerationMethods,
  });

  final String id;
  final String label;
  final List<String> supportedGenerationMethods;

  bool get supportsGenerateContent =>
      supportedGenerationMethods.contains('generateContent');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiModelOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          _listEquals(
            supportedGenerationMethods,
            other.supportedGenerationMethods,
          );

  @override
  int get hashCode =>
      Object.hash(id, label, Object.hashAll(supportedGenerationMethods));

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
