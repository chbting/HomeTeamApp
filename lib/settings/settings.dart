import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/settings/settings_ui.dart';
import 'package:tner_client/ui/radio_list_dialog.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

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
  Widget build(BuildContext context) {
    for (var element in _localeStringList) {
      _languageList.add(_localeStringToLanguage(element, context));
    }
    return Column(
      children: [
        AppBar(
          title: Text(S.of(context).settings),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SettingsUI.getSettingsTitle(
                  context, S.of(context).general_settings),
              SwitchListTile(
                title: Text(S.of(context).darkMode),
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
                  title: Text(S.of(context).language),
                  subtitle:
                      Text(_localeStringToLanguage(_localeString, context)),
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
                        S.of(context).choose_language, (value) {
                      _localeString = value;
                      SharedPreferencesHelper().setLocale(
                          SharedPreferencesHelper.stringToLocale(value));
                    });
                  }),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

String _localeStringToLanguage(String locale, BuildContext context) {
  switch (locale) {
    case 'en':
      return S.of(context).english;
    case 'zh_Hant':
      return S.of(context).traditional_chinese;
    case 'zh_Hans':
      return S.of(context).simplified_chinese;
    default:
      return 'unknown';
  }
}
