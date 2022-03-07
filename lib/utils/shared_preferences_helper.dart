import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tner_client/utils/text_helper.dart';

class SharedPreferencesHelper {
  static const String darkModeOnKey = 'darkMode';
  static const String localeKey = 'locale';

  static late SharedPreferences _prefs;
  static late ValueNotifier themeNotifier, localeNotifier;

  static final SharedPreferencesHelper _helperInstance =
      SharedPreferencesHelper._constructor();

  factory SharedPreferencesHelper() => _helperInstance;

  SharedPreferencesHelper._constructor();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
    themeNotifier = ValueNotifier(_helperInstance.isDarkMode());
    localeNotifier = ValueNotifier(localeToString(_helperInstance.getLocale()));
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

  setDarkModeOn(bool darkModeOn) {
    _prefs.setBool(darkModeOnKey, darkModeOn);
    themeNotifier.value = darkModeOn;
  }

  bool isDarkMode() =>
      _prefs.getBool(darkModeOnKey) ??
      (Brightness.dark == SchedulerBinding.instance!.window.platformBrightness);

  setLocale(Locale locale) {
    String newValue = localeToString(locale);
    _prefs.setString(localeKey, newValue);
    localeNotifier.value = newValue;
  }

  Locale getLocale() {
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

  String getVoiceRecognitionLocaleId() {
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

  static String getVoiceRecognitionLanguage(String localeId) {
    switch (localeId) {
      case 'en_GB':
        return TextHelper.appLocalizations.english_voice_input;
      case 'yue_HK':
        return TextHelper.appLocalizations.cantonese;
      case 'cmn_CN':
        return TextHelper.appLocalizations.mandarin;
      default:
        return TextHelper.appLocalizations.english;
    }
  }
}
