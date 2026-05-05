import '../ai_configuration.dart';
import '../ai_model_option.dart';

abstract class AiConfigurationRepository {
  Future<AiConfiguration> getConfiguration();

  Future<List<AiModelOption>> fetchAvailableModels({String? apiKey});

  Future<void> saveApiKey(String apiKey);

  Future<void> saveSelectedModel(String modelId);

  Future<void> saveThinkingLevel(String thinkingLevel);

  Future<void> clearConfiguration();
}
