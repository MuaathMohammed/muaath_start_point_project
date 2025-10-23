import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/sample-data-generated.dart';
import '../../providers/repository_providers.dart';

Future<void> generateSampleData() async {
  print('🚀 Starting sample data generation...');

  final container = ProviderContainer();

  try {
    final generator = SampleDataGenerator(
      appSettingsRepository: container.read(appSettingsRepositoryProvider),
    );

    await generator.generateAllSampleData();
  } catch (e) {
    print(' Error generating sample data: $e');
  }
}
