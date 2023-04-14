import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

/// 3 levels of data: String (label), String (locale value), Locale
class LocaleHelper {
  static final List<String> supportedLocales = [
    'zh_Hant',
    'zh_Hans',
    'en'
  ];

  /// Sting (locale value) => Locale
  static Locale parse(String value) {
    switch (value) {
      case 'zh_Hant':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      case 'zh_Hans':
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      case 'en':
      default:
        return const Locale.fromSubtags(languageCode: 'en');
    }
  }

  /// String (locale value) => String (label)
  static String getLabel(String value) {
    switch (value) {
      case 'zh_Hant':
        return '䌓體中文';
      case 'zh_Hans':
        return '简体中文';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Locale => String (locale value)
  static String getString(Locale locale) {
    String value = locale.languageCode;
    if (locale.scriptCode != null) {
      value += '_${locale.scriptCode}';
    }
    return value;
  }

  /// Locale => String (label)
  static String localeToLabel(Locale locale) => getLabel(getString(locale));

  static String getVoiceRecognitionLocaleId(BuildContext context) {
    String value = getString(SharedPreferencesHelper.getLocale());
    switch (value) {
      case 'zh_Hant':
        return 'yue_HK';
      case 'zh_Hans':
        return 'cmn_CN';
      case 'en':
      default:
        return 'en_GB'; //todo
    }
  }

  static String getVoiceRecognitionLanguage(
      String localeId, BuildContext context) {
    switch (localeId) {
      case 'yue_HK':
        return S.of(context).cantonese;
      case 'cmn_CN':
        return S.of(context).mandarin;
      case 'en':
        return S.of(context).english_voice_input;
      default:
        return 'English';
    }
  }
}
