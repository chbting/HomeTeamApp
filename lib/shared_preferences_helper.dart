import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String darkModeOnKey = 'darkModeOn';
  static const String localeKey = 'locale';

  static late SharedPreferences _prefs;
  static late ValueNotifier themeNotifier, localeNotifier;

  static final SharedPreferencesHelper _helperInstance =
      SharedPreferencesHelper._constructor();

  factory SharedPreferencesHelper() => _helperInstance;

  SharedPreferencesHelper._constructor();

  static ensureInitialized() async {
    _prefs = await SharedPreferences.getInstance();
    themeNotifier = ValueNotifier(_helperInstance.isDarkModeOn());
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

  bool isDarkModeOn() =>
      _prefs.getBool(darkModeOnKey) ?? false; //TODO get system default

  setLocale(Locale locale) {
    String newValue = localeToString(locale);
    _prefs.setString(localeKey, newValue);
    localeNotifier.value = newValue;
  }

  Locale getLocale() {
    String value = _prefs.getString(localeKey) ?? 'en';
    return stringToLocale(value);
  }

  //  TODO System default Localizations.localeOf(context).languageCode;
}
