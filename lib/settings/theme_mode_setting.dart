import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

class ThemeModeHelper {
  static ThemeMode parseThemeMode(String? value, ThemeMode defaultThemeMode) =>
      ThemeMode.values.firstWhere((themeMode) => themeMode.name == value,
          orElse: () => defaultThemeMode);

  static String getThemeModeLabel(BuildContext context, ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return S.of(context).setting_off;
      case ThemeMode.dark:
        return S.of(context).setting_on;
      case ThemeMode.system:
        return S.of(context).use_system_settings;
      default:
        return S.of(context).use_system_settings;
    }
  }
}
