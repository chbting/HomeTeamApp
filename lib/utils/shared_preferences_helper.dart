import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tner_client/settings/locale_helper.dart';
import 'package:tner_client/settings/theme_mode_setting.dart';

class SharedPreferencesHelper {
  static const String themeModeKey = 'themeMode';
  static const String localeKey = 'locale';
  static const Locale defaultLocale = Locale.fromSubtags(languageCode: 'en');
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  static late SharedPreferences _prefs;

  static SharedPreferencesChangedNotifier changeNotifier =
      SharedPreferencesChangedNotifier();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
    _ensureLocaleSettingInitialized();
  }

  /// Returns [ThemeMode.system] by default
  static ThemeMode getThemeMode() => ThemeModeHelper.parseThemeMode(
      _prefs.getString(themeModeKey), defaultThemeMode);

  static void setThemeMode(ThemeMode themeMode) {
    _prefs.setString(themeModeKey, themeMode.name);
    changeNotifier.notify();
  }

  static Locale getLocale() => _getInitialLocale() ?? defaultLocale;

  static Locale? _getInitialLocale() {
    String? value = _prefs.getString(localeKey);
    return value == null ? null : LocaleHelper.parseLocale(value);
  }

  static void setLocale(Locale locale, {bool notifyChange = true}) {
    _prefs.setString(localeKey, LocaleHelper.localeToValue(locale));
    if (notifyChange) {
      changeNotifier.notify();
    }
  }

  /// Set to 'en' by default
  static void _ensureLocaleSettingInitialized() {
    if (_getInitialLocale() == null) {
      List<String> localeCodes = Platform.localeName.split('_');
      String languageCode = localeCodes[0];
      String? scriptCode = localeCodes.length > 1 ? localeCodes[1] : null;
      late Locale locale;
      switch (languageCode) {
        case 'zh':
          if (scriptCode == 'Hant') {
            locale = const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant');
          } else if (scriptCode == 'Hans') {
            locale = const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans');
          } else {
            // Default to Traditional Chinese for generic Chinese
            locale = const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant');
          }
          break;
        case 'en':
        default:
          locale = defaultLocale;
          break;
      }
      setLocale(locale, notifyChange: false);
    }
  }
}

class SharedPreferencesChangedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
