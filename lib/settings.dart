import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/shared_preferences_helper.dart';
import 'package:tner_client/ui/radio_list_dialog.dart';
import 'package:tner_client/ui/settings_ui_elements.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final List<String> _localeStringList = ['zh_Hant', 'zh_Hans', 'en'];
  final List<String> _languageList = [];

  bool _darkMode = SharedPreferencesHelper().isDarkMode();
  String _localeString = SharedPreferencesHelper.localeToString(
      SharedPreferencesHelper().getLocale());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for (var element in _localeStringList) {
        _languageList.add(_localeStringToLanguage(element, context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: ListView(
          children: <Widget>[
            SettingsUI.getSettingsTitle(
                context, AppLocalizations.of(context)!.general_settings),
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
            ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                subtitle: Text(_localeStringToLanguage(_localeString, context)),
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
                      _localeStringList,
                      _languageList,
                      _localeString,
                      AppLocalizations.of(context)!.choose_language, (value) {
                    _localeString = value;
                    SharedPreferencesHelper().setLocale(
                        SharedPreferencesHelper.stringToLocale(value));
                  });
                }),
            const Divider(
              thickness: 1,
            ),
          ],
        )); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

String _localeStringToLanguage(String locale, BuildContext context) {
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
