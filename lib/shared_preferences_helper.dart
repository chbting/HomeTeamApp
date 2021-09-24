import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper extends CacheProvider {
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

  @override
  bool? containsKey(String key) {
    return _prefs.containsKey(key);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  int? getInt(String key) {
    _prefs.getInt(key);
  }

  @override
  Set? getKeys() {
    return _prefs.getKeys();
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    return _prefs.get(key) as T;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> remove(String key) async {
    _prefs.remove(key);
  }

  @override
  Future<void> removeAll() async {
    Set<String> set = _prefs.getKeys();
    for (var element in set) {
      _prefs.remove(element);
    }
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue}) async {
    _prefs.setBool(key, value!);
  }

  @override
  Future<void> setDouble(String key, double? value,
      {double? defaultValue}) async {
    _prefs.setDouble(key, value!);
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue}) async {
    _prefs.setInt(key, value!);
  }

  @override
  Future<void> setObject<T>(String key, T value) async {
    // TODO json serialize
  }

  @override
  Future<void> setString(String key, String? value,
      {String? defaultValue}) async {
    _prefs.setString(key, value!);
  }
}
