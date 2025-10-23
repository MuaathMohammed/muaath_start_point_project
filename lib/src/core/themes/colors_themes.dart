import 'package:flutter/material.dart';

import '../consts/app_constants.dart';

class AppColorSchemes {
  static Map<String, ColorScheme> generateColorSchemes(Color primaryColor) {
    return {
      AppConstants.lightTheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.8),
        secondary: _getSecondaryColor(primaryColor),
        secondaryContainer: _getSecondaryColor(primaryColor).withOpacity(0.8),
        surface: Colors.white,
        background: Colors.grey[50]!,
        error: Colors.red.shade700,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      AppConstants.darkTheme: ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.8),
        secondary: _getSecondaryColor(primaryColor),
        secondaryContainer: _getSecondaryColor(primaryColor).withOpacity(0.8),
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: Colors.red.shade400,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
    };
  }

  static Color _getSecondaryColor(Color primary) {
    // Generate a complementary color
    final hsl = HSLColor.fromColor(primary);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  // Predefined color schemes
  static ColorScheme get blueLight =>
      generateColorSchemes(const Color(0xFF2563EB))[AppConstants.lightTheme]!;
  static ColorScheme get blueDark =>
      generateColorSchemes(const Color(0xFF2563EB))[AppConstants.darkTheme]!;

  static ColorScheme get greenLight =>
      generateColorSchemes(const Color(0xFF059669))[AppConstants.lightTheme]!;
  static ColorScheme get greenDark =>
      generateColorSchemes(const Color(0xFF059669))[AppConstants.darkTheme]!;

  static ColorScheme get purpleLight =>
      generateColorSchemes(const Color(0xFF7C3AED))[AppConstants.lightTheme]!;
  static ColorScheme get purpleDark =>
      generateColorSchemes(const Color(0xFF7C3AED))[AppConstants.darkTheme]!;
}
