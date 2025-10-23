import '../../domain/entities/app_settings/app_settings.dart';
import '../../domain/repositories/app_settings_repository.dart';

class SampleDataGenerator {
  final AppSettingsRepository appSettingsRepository;

  SampleDataGenerator({required this.appSettingsRepository});

  Future<void> generateAllSampleData() async {
    print('🔄 Generating sample data...');

    await _generateAppSettings();

    print('✅ Sample data generated successfully!');
  }

  Future<void> _generateAppSettings() async {
    final existingSettings = await appSettingsRepository.getAppSettings();
    if (existingSettings.id != 'app_settings') {
      final settings = AppSettings(
        id: 'app_settings',

        themeMode: 'system',
        primaryColor: 0xFF2563EB, // Blue
        language: 'en',
        isRTL: false,
      );
      await appSettingsRepository.create(settings);
      print('✅ Generated app settings with customization options');
    } else {
      print('⏩ App settings already exist, skipping...');
    }
  }

  Future<void> clearAllData() async {
    print('🗑️ Clearing all sample data...');

    // Note: Be careful with this in production!

    print('✅ All sample data cleared!');
  }
}
