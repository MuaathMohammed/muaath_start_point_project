// lib/src/presentation/myapp_screen/my_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../core/config/app_config.dart';
import '../../core/consts/app_constants.dart';
import '../../core/localizations/app_localizations.dart';
import '../../core/services/security_service.dart';
import '../../core/themes/app_theme.dart';
import '../../domain/entities/app_settings/app_settings.dart';
import '../../providers/providers.dart';
import '../screens/home/home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsStateProvider);

    return settingsAsync.when(
      loading: () => _buildLoadingApp(),
      error: (error, stack) => _buildErrorApp(error),
      data: (settings) => _buildMainApp(context, settings, ref),
    );
  }

  Widget _buildLoadingApp() {
    return MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildErrorApp(Object error) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load app settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add retry logic
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkFirstTimeSetup(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    // Check if it's first time and PIN is not set
    if (settings.pinCode == '0000' && !settings.requirePin) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        SecurityService.showFirstTimeSetupDialog(context, ref);
      });
    }
  }

  Widget _buildMainApp(BuildContext context, AppSettings settings, ref) {
    // Check if first time setup is needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeSetup(context, ref, settings);
    });

    final themeMode = _getEffectiveTheme(settings);
    final primaryColor = settings.primaryColorValue;
    final language = settings.language;
    final isRTL = settings.isRTL;
    return MaterialApp(
      title: AppConfig.appName,
      navigatorKey: navigatorKey,
      theme: AppTheme.getTheme(
        themeMode: AppConstants.lightTheme,
        primaryColor: primaryColor,
        isRTL: isRTL,
      ),
      darkTheme: AppTheme.getTheme(
        themeMode: AppConstants.darkTheme,
        primaryColor: primaryColor,
        isRTL: isRTL,
      ),
      themeMode: themeMode == AppConstants.darkTheme
          ? ThemeMode.dark
          : ThemeMode.light,
      locale: Locale(language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }

  String _getEffectiveTheme(AppSettings settings) {
    if (settings.themeMode == AppConstants.systemTheme) {
      return AppTheme.getSystemBrightness() == Brightness.dark
          ? AppConstants.darkTheme
          : AppConstants.lightTheme;
    }
    return settings.themeMode;
  }
}
