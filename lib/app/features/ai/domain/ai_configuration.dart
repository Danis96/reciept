class AiConfiguration {
  static const String minimalThinkingLevel = 'MINIMAL';
  static const String highThinkingLevel = 'HIGH';

  const AiConfiguration({
    required this.apiKey,
    required this.selectedModel,
    this.thinkingLevel = minimalThinkingLevel,
    this.isUsingBuiltInApiKey = false,
  });

  final String apiKey;
  final String selectedModel;
  final String thinkingLevel;
  final bool isUsingBuiltInApiKey;

  bool get hasApiKey => apiKey.trim().isNotEmpty;
  bool get isThinkingEnabled => thinkingLevel != minimalThinkingLevel;

  AiConfiguration copyWith({
    String? apiKey,
    String? selectedModel,
    String? thinkingLevel,
    bool? isUsingBuiltInApiKey,
  }) {
    return AiConfiguration(
      apiKey: apiKey ?? this.apiKey,
      selectedModel: selectedModel ?? this.selectedModel,
      thinkingLevel: thinkingLevel ?? this.thinkingLevel,
      isUsingBuiltInApiKey: isUsingBuiltInApiKey ?? this.isUsingBuiltInApiKey,
    );
  }
}
