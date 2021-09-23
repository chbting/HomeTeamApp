import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = SharedPreferencesHelper().isDarkModeOn();
  String locale = SharedPreferencesHelper().getLocale();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
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
          thickness: 1.2,
        ),
      ],
    )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

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
    localeNotifier = ValueNotifier(_helperInstance.getLocale());
  }

  setDarkModeOn(bool darkModeOn) {
    _prefs.setBool(darkModeOnKey, darkModeOn);
    themeNotifier.value = darkModeOn;
  }

  bool isDarkModeOn() =>
      _prefs.getBool(darkModeOnKey) ?? false; //TODO get system default

  setLocale(String locale) {
    _prefs.setString(localeKey, locale);
  }

  String getLocale() =>
      _prefs.getString(localeKey) ?? 'en'; //TODO get system default
//  String locale = Localizations.localeOf(context).languageCode;
}
