import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/shared_preferences_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _darkMode = SharedPreferencesHelper().isDarkModeOn();
  String localeString = SharedPreferencesHelper.localeToString(
      SharedPreferencesHelper().getLocale());

  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(Icons.language), //todo center
            onTap: () {
              showLanguageDialog(context);
            }),
        const Divider(
          thickness: 1,
        ),
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  void showLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.choose_language),
              content: SizedBox(
                  width: double.minPositive,
                  child: RadioListView(
                      const ['zh_Hant', 'zh_Hans', 'en'], localeString,
                      (value) {
                    localeString = value;
                    SharedPreferencesHelper().setLocale(
                        SharedPreferencesHelper.stringToLocale(value));
                  })),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  static String localeStringToLanguage(String locale, BuildContext context) {
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

class RadioListView extends StatefulWidget {
  final List<String> list;
  final Function(String) callback;
  final String defaultValue;

  const RadioListView(this.list, this.defaultValue, this.callback, {Key? key})
      : super(key: key);

  @override
  State<RadioListView> createState() => RadioListViewState();
}

class RadioListViewState extends State<RadioListView> {
  String currentValue = ''; //todo
  //currentValue = widget.defaultValue;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(SettingsPageState.localeStringToLanguage(
              widget.list[index], context)),
          value: widget.list[index],
          groupValue: currentValue,
          // TODO onTap as well
          onChanged: (String? value) {
            setState(() {
              currentValue = value!;
              Navigator.of(context).pop();
              widget.callback(value);
            });
          },
        );
      },
    );
  }
}
