import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/auth/firebase_ui_localizations/en.dart';
import 'package:hometeam_client/auth/firebase_ui_localizations/zh.dart';
import 'package:hometeam_client/auth/firebase_ui_localizations/zh_tw.dart';
import 'package:hometeam_client/generated/l10n.dart';

class FirebaseUIAuthLocalizationsOverrides {
  FirebaseUIAuthLocalizationsOverrides(this.locale);

  final Locale locale;

  static FirebaseUIAuthLocalizationsOverridesDelegate delegate =
      const FirebaseUIAuthLocalizationsOverridesDelegate();

  static FirebaseUIAuthLocalizationsOverrides of(BuildContext context) {
    return Localizations.of<FirebaseUIAuthLocalizationsOverrides>(
        context, FirebaseUIAuthLocalizationsOverrides)!;
  }
}

class FirebaseUIAuthLocalizationsOverridesDelegate
    extends LocalizationsDelegate<FirebaseUILocalizations> {
  const FirebaseUIAuthLocalizationsOverridesDelegate();

  @override
  bool isSupported(Locale locale) =>
      S.delegate.supportedLocales.contains(locale);

  @override
  Future<FirebaseUILocalizations> load(Locale locale) {
    late FirebaseUILocalizationLabels l;

    final key = locale.languageCode;
    final scriptCode = locale.scriptCode;
    var fullKey = key;
    scriptCode != null ? fullKey += '_$scriptCode' : null;

    switch (fullKey) {
      case 'zh':
        l = const ZhLocalizations();
        break;
      case 'zh_Hans':
        l = const ZhLocalizations();
        break;
      case 'zh_Hant':
        l = const ZhTWLocalizations();
        break;
      default:
        l = const EnLocalizations();
        break;
    }
    return SynchronousFuture<FirebaseUILocalizations>(
        FirebaseUILocalizations(locale, l));
  }

  @override
  bool shouldReload(FirebaseUIAuthLocalizationsOverridesDelegate old) => false;
}
