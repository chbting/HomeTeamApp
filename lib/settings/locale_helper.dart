import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class LocaleHelper {
  static final List<String> supportedLocaleValues = [
    'zh_Hant',
    'zh_Hans',
    'en'
  ];

  /// valueToLocale
  static Locale parseLocale(String value) {
    List<String> list = value.split('_');
    if (list.length == 1) {
      return Locale.fromSubtags(languageCode: value);
    } else {
      return Locale.fromSubtags(languageCode: list[0], scriptCode: list[1]);
    }
  }

  static String valueToLabel(String value) {
    switch (value) {
      case 'en':
        return 'English';
      case 'zh_Hant':
        return '䌓體中文';
      case 'zh_Hans':
        return '简体中文';
      default:
        return 'English';
    }
  }

  static String localeToValue(Locale locale) {
    String value = locale.languageCode;
    if (locale.scriptCode != null) {
      value += '_${locale.scriptCode}';
    }
    return value;
  }

  static String localeToLabel(Locale locale) =>
      valueToLabel(localeToValue(locale));

  static String getVoiceRecognitionLocaleId(BuildContext context) {
    String value = localeToValue(SharedPreferencesHelper.getLocale());
    switch (value) {
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
