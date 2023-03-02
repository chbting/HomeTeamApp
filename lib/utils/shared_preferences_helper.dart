import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tner_client/settings/locale_helper.dart';
import 'package:tner_client/settings/theme_mode_setting.dart';

class SharedPreferencesHelper {
  static const String themeModeKey = 'themeMode';
  static const String localeKey = 'locale';

  static late SharedPreferences _prefs;

  static SharedPreferencesChangedNotifier changeNotifier =
      SharedPreferencesChangedNotifier();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Returns [ThemeMode.system] by default
  static ThemeMode getThemeMode() => ThemeModeHelper.parseThemeMode(
      _prefs.getString(themeModeKey), ThemeMode.system);

  static void setThemeMode(ThemeMode themeMode) {
    _prefs.setString(themeModeKey, themeMode.name);
    changeNotifier.notify();
  }

  /// Returns 'en' Locale by default
  static Locale getLocale() {
    String? value = _prefs.getString(localeKey); //todo get system language
    return value != null
        ? LocaleHelper.parseLocale(value)
        : const Locale.fromSubtags(languageCode: 'en');
  }

  static void setLocale(Locale locale) {
    _prefs.setString(localeKey, LocaleHelper.localeToValue(locale));
    changeNotifier.notify();
  }
}

class SharedPreferencesChangedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
