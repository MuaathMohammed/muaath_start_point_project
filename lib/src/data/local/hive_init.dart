import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/app_settings/app_settings.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register ALL adapters

    Hive.registerAdapter(AppSettingsAdapter());

    await Hive.openBox<AppSettings>('app_settings');
    print('Hive initialized successfully with all adapters');
  }
}
