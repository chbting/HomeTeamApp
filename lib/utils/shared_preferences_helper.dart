import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hometeam_client/settings/locale_helper.dart';
import 'package:hometeam_client/settings/theme_mode_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys
  static const String localeKey = 'locale';
  static const String themeModeKey = 'themeMode';
  static const String landlordModeKey = 'landlordMode';

  // Default values
  static const Locale defaultLocale = Locale.fromSubtags(languageCode: 'en');
  static const ThemeMode defaultThemeMode = ThemeMode.system;
  static const bool defaultLandlordMode = false;

  static late SharedPreferences _prefs;

  static SharedPreferencesChangedNotifier changeNotifier =
      SharedPreferencesChangedNotifier();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.getString(localeKey) ?? _initializeLocaleSetting();
    _prefs.getString(themeModeKey) ??
        _prefs.setString(themeModeKey, defaultThemeMode.name);
    _prefs.getBool(landlordModeKey) ??
        _prefs.setBool(landlordModeKey, defaultLandlordMode);
  }
  
  static Locale getLocale() {
    String? value = _prefs.getString(localeKey);
    return value == null
        ? defaultLocale
        : LocaleHelper.parse(value);
  }

  static void setLocale(Locale locale) {
    _prefs.setString(localeKey, LocaleHelper.getString(locale));
    changeNotifier.notify();
  }

  /// Set to 'en' by default
  static void _initializeLocaleSetting() {
    List<String> localeCodes = Platform.localeName.split('_');
    String languageCode = localeCodes[0];
    String? scriptCode = localeCodes.length > 1 ? localeCodes[1] : null;
    late Locale locale;
    switch (languageCode) {
      case 'zh':
        if (scriptCode == 'Hant') {
          locale =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
        } else if (scriptCode == 'Hans') {
          locale =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
        } else {
          // Default to Traditional Chinese for generic Chinese
          locale =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
        }
        break;
      case 'en':
      default:
        locale = defaultLocale;
        break;
    }
    _prefs.setString(localeKey, LocaleHelper.getString(locale));
  }

  /// Returns [ThemeMode.system] by default
  static ThemeMode getThemeMode() => ThemeModeHelper.parseThemeMode(
      _prefs.getString(themeModeKey), defaultThemeMode);

  static void setThemeMode(ThemeMode themeMode) {
    _prefs.setString(themeModeKey, themeMode.name);
    changeNotifier.notify();
  }

  /// Returns false by default
  static bool getLandlordMode() =>
      _prefs.getBool(landlordModeKey) ?? defaultLandlordMode;

  static void setLandlordMode(bool landlordMode) {
    _prefs.setBool(landlordModeKey, landlordMode);
    changeNotifier.notify();
  }
}

class SharedPreferencesChangedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
