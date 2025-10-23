import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/seeds/generate_simple_data.dart';
import 'src/data/local/hive_init.dart';
import 'src/presentation/myapp_screen/my_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInit.init();
  //await DatabaseService().initialize();
  // Generate sample data (only for development)
  await generateSampleData();

  runApp(const ProviderScope(child: MyApp()));
}
