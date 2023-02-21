import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tner_client/generated/l10n.dart';

class SharedPreferencesHelper {
  static const String darkModeOnKey = 'darkMode';
  static const String themeModeKey = 'themeMode';
  static const String localeKey = 'locale';

  static late SharedPreferences _prefs;

  static SharedPreferencesChangedNotifier changeNotifier =
      SharedPreferencesChangedNotifier();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String localeToString(Locale locale) {
    if (locale.scriptCode == null) {
      return locale.languageCode;
    } else {
      return '${locale.languageCode}_${locale.scriptCode}';
    }
  }

  static Locale stringToLocale(String value) {
    List<String> list = value.split('_');
    if (list.length == 1) {
      return Locale.fromSubtags(languageCode: value);
    } else {
      return Locale.fromSubtags(languageCode: list[0], scriptCode: list[1]);
    }
  }

  static setDarkModeOn(bool darkModeOn) {
    _prefs.setBool(darkModeOnKey, darkModeOn);
    changeNotifier.notify();
  }

  static bool isDarkMode() =>
      _prefs.getBool(darkModeOnKey) ??
      (Brightness.dark == SchedulerBinding.instance.window.platformBrightness);

  static ThemeMode getThemeMode() {
    var value = _prefs.getString(themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static void setThemeMode(ThemeMode themeMode) {
    _prefs.setString(themeModeKey, themeMode.name);
  }

  static void setLocale(Locale locale) {
    String newValue = localeToString(locale);
    _prefs.setString(localeKey, newValue);
    changeNotifier.notify();
  }

  static Locale getLocale() {
    String? savedValue = _prefs.getString(localeKey);
    if (savedValue != null) {
      return stringToLocale(savedValue);
    } else {
      String languageCode = Platform.localeName.split('_')[0];
      switch (languageCode) {
        case 'en':
          return stringToLocale(languageCode);
        case 'zh':
          return stringToLocale(
              '${languageCode}_${Platform.localeName.split('_')[1]}');
        default:
          return stringToLocale('en'); // Default to English
      }
    }
  }

  static String getVoiceRecognitionLocaleId() {
    String savedValue = _prefs.getString(localeKey)!;
    switch (savedValue) {
      case 'en':
        return 'en_GB';
      case 'zh_Hant':
        return 'yue_HK';
      case 'zh_Hans':
        return 'cmn_CN';
      default:
        return 'en_GB';
    }
  }

  static String getVoiceRecognitionLanguage(
      String localeId, BuildContext context) {
    switch (localeId) {
      case 'en_GB':
        return S.of(context).english_voice_input;
      case 'yue_HK':
        return S.of(context).cantonese;
      case 'cmn_CN':
        return S.of(context).mandarin;
      default:
        return 'English';
    }
  }
}

class SharedPreferencesChangedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
