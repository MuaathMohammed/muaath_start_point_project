import '../entities/app_settings/app_settings.dart';
import 'generics/generic_repository.dart';

abstract class AppSettingsRepository implements GenericRepository<AppSettings> {
  Future<AppSettings> getAppSettings();
}
