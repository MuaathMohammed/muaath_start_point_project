import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repositories/generic/generic_repository_impl.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 30)
class AppSettings implements EntityWithId {
  @HiveField(0)
  @override
  final String id;

  // Theme Settings
  @HiveField(1)
  final String themeMode; // light, dark, system

  @HiveField(2)
  final int primaryColor; // Store as hex value

  @HiveField(3)
  final String customTheme; // Custom theme name if any

  // Language & Regional
  @HiveField(4)
  final String language; // en, ar

  @HiveField(5)
  final bool isRTL;

  @HiveField(6)
  final String dateFormat;

  @HiveField(7)
  final String timeFormat;

  // Business Settings

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  @HiveField(10)
  final bool isDirty;
  // Security
  @HiveField(11)
  final bool requirePin;

  @HiveField(12)
  final String pinCode;

  AppSettings({
    String? id,

    this.themeMode = 'system',
    this.primaryColor = 0xFF2563EB, // Default blue
    this.customTheme = '',
    this.language = 'en',
    this.isRTL = false,
    this.dateFormat = 'MM/dd/yyyy',
    this.timeFormat = '12h',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.requirePin = false,
    this.pinCode = '0000',
    this.isDirty = false,
  }) : id = id ?? 'app_settings',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert hex color to Color object
  Color get primaryColorValue => Color(primaryColor);

  // Check if language is RTL
  bool get isLanguageRTL => language == 'ar';

  AppSettings copyWith({
    String? themeMode,
    int? primaryColor,
    String? customTheme,
    String? language,
    bool? isRTL,
    String? dateFormat,
    String? timeFormat,
    bool? requirePin,
    String? pinCode,
    bool? isDirty,
  }) {
    return AppSettings(
      id: id,

      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      customTheme: customTheme ?? this.customTheme,
      language: language ?? this.language,
      isRTL: isRTL ?? this.isRTL,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      requirePin: requirePin ?? this.requirePin,
      pinCode: pinCode ?? this.pinCode,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isDirty: isDirty ?? this.isDirty,
    );
  }

  // In AppSettings entity, add this method:
  AppSettings updatePin(String newPin) {
    return copyWith(
      pinCode: newPin,
      requirePin: true, // Auto-enable when PIN is set
      isDirty: true,
    );
  }
}
