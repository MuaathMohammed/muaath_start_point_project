import 'package:hive/hive.dart';
import 'package:muaath_start_point_project/src/core/config/app_config.dart';

import '../../domain/entities/app_settings/app_settings.dart';
import '../../domain/repositories/app_settings_repository.dart';
import 'generic/generic_repository_impl.dart';

class AppSettingsRepositoryImpl extends GenericRepositoryImpl<AppSettings>
    implements AppSettingsRepository {
  AppSettingsRepositoryImpl()
    : super(Hive.box<AppSettings>(AppConfig.appSettingBox));

  @override
  Future<AppSettings> getAppSettings() async {
    final settings = await getById(AppConfig.appSettingBox);
    if (settings == null) {
      // Create default settings
      final defaultSettings = AppSettings(id: AppConfig.appSettingBox);
      await create(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }
}
