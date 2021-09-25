import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/settings_ui/radio_list_dialog.dart';
import 'package:tner_client/shared_preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  List<String> localeStringList = ['zh_Hant', 'zh_Hans', 'en'];
  List<String> languageList = [];

  bool _darkMode = SharedPreferencesHelper().isDarkModeOn();
  String localeString = SharedPreferencesHelper.localeToString(
      SharedPreferencesHelper().getLocale());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for (var element in localeStringList) {
        languageList.add(localeStringToLanguage(element, context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    for (var element in localeStringList) {
      languageList.add(localeStringToLanguage(element, context));
    }
    return ListView(
      children: <Widget>[
        SwitchListTile(
          title: Text(AppLocalizations.of(context)!.darkMode),
          secondary: const Icon(Icons.dark_mode),
          onChanged: (value) {
            setState(() {
              _darkMode = value;
              SharedPreferencesHelper().setDarkModeOn(value);
            });
          },
          value: _darkMode,
        ),
        const Divider(
          thickness: 1,
        ),
        ListTile(
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(localeStringToLanguage(localeString, context)),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.language),
              ],
            ),
            onTap: () {
              RadioListDialog.show(
                  context,
                  localeStringList,
                  languageList,
                  localeString,
                  AppLocalizations.of(context)!.choose_language, (value) {
                localeString = value;
                SharedPreferencesHelper()
                    .setLocale(SharedPreferencesHelper.stringToLocale(value));
              });
            }),
        const Divider(
          thickness: 1,
        ),
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  String localeStringToLanguage(String locale, BuildContext context) {
    switch (locale) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'zh_Hant':
        return AppLocalizations.of(context)!.traditional_chinese;
      case 'zh_Hans':
        return AppLocalizations.of(context)!.simplified_chinese;
      default:
        return 'unknown';
    }
  }
}
