import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/consts/app_constants.dart';
import '../domain/entities/app_settings/app_settings.dart';
import '../domain/repositories/app_settings_repository.dart';
import 'providers.dart';
import 'repository_providers.dart';

// App Settings State
// App Settings State - WITH AUTO DISPOSE
final appSettingsStateProvider =
    StateNotifierProvider.autoDispose<
      AppSettingsNotifier,
      AsyncValue<AppSettings>
    >((ref) {
      final repository = ref.read(appSettingsRepositoryProvider);
      return AppSettingsNotifier(repository);
    });

class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final AppSettingsRepository _repository;

  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _repository.getAppSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTheme(String themeMode, Color primaryColor) async {
    try {
      final currentSettings = state.value;
      if (currentSettings != null) {
        final updated = currentSettings.copyWith(
          themeMode: themeMode,
          primaryColor: primaryColor.value,
          isDirty: true,
        );
        await _repository.update(updated);
        await loadSettings();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateLanguage(String language) async {
    try {
      final currentSettings = state.value;
      if (currentSettings != null) {
        final updated = currentSettings.copyWith(
          language: language,
          isRTL: language == 'ar',
          isDirty: true,
        );
        await _repository.update(updated);
        await loadSettings();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSecuritySettings(bool requirePin, String pinCode) async {
    try {
      final currentSettings = state.value;
      if (currentSettings != null) {
        final updated = currentSettings.copyWith(
          requirePin: requirePin,
          pinCode: pinCode,
          isDirty: true,
        );
        await _repository.update(updated);
        await loadSettings();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  // In AppSettingsNotifier, add this method:
  Future<void> updatePinCode(String newPin) async {
    try {
      final currentSettings = state.value;
      if (currentSettings != null) {
        final updated = currentSettings.updatePin(newPin);
        await _repository.update(updated);
        await loadSettings();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Theme Provider
final currentThemeProvider = Provider<String>((ref) {
  final settingsAsync = ref.watch(appSettingsStateProvider);
  return settingsAsync.when(
    data: (settings) => settings.themeMode,
    loading: () => AppConstants.lightTheme,
    error: (_, __) => AppConstants.lightTheme,
  );
});

// Language Provider
final currentLanguageProvider = Provider<String>((ref) {
  final settingsAsync = ref.watch(appSettingsStateProvider);
  return settingsAsync.when(
    data: (settings) => settings.language,
    loading: () => AppConstants.english,
    error: (_, __) => AppConstants.english,
  );
});

// Primary Color Provider
final primaryColorProvider = Provider<Color>((ref) {
  final settingsAsync = ref.watch(appSettingsStateProvider);
  return settingsAsync.when(
    data: (settings) => settings.primaryColorValue,
    loading: () => const Color(0xFF2563EB),
    error: (_, __) => const Color(0xFF2563EB),
  );
});

// RTL Provider
final isRTLProvider = Provider<bool>((ref) {
  final settingsAsync = ref.watch(appSettingsStateProvider);
  return settingsAsync.when(
    data: (settings) => settings.isRTL,
    loading: () => false,
    error: (_, __) => false,
  );
});
