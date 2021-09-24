import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:tner_client/properties.dart';
import 'package:tner_client/settings.dart';
import 'package:tner_client/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.ensureInitialized();
  await Settings.init(cacheProvider: SharedPreferencesHelper());

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => RootAppState();
}

class RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild:${SharedPreferencesHelper().getLocale()}');
    return ValueListenableBuilder(
      valueListenable: SharedPreferencesHelper.themeNotifier,
      builder: (context, value, _) {
        return ValueListenableBuilder(
          valueListenable: SharedPreferencesHelper.localeNotifier,
          builder: (context, value, _) {
            return MaterialApp(
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''),
                  Locale.fromSubtags(languageCode: 'zh'),
                  Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
                  Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
                  Locale.fromSubtags(
                      languageCode: 'zh',
                      scriptCode: 'Hans',
                      countryCode: 'CN'),
                  Locale.fromSubtags(
                      languageCode: 'zh',
                      scriptCode: 'Hant',
                      countryCode: 'TW'),
                  Locale.fromSubtags(
                      languageCode: 'zh',
                      scriptCode: 'Hant',
                      countryCode: 'HK'),
                ],
                home: const AppHome(),
                theme: SharedPreferencesHelper().isDarkModeOn()
                    ? ThemeData.dark()
                    : ThemeData.light(),
                locale: SharedPreferencesHelper().getLocale());
          },
        );
      },
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => AppHomeState();
}

class AppHomeState extends State<AppHome> {
  static int _selectedIndex = 0; // Default value

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> options = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.business),
        label: AppLocalizations.of(context)!.properties,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.construction),
        label: AppLocalizations.of(context)!.remodelling,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.paste),
        label: AppLocalizations.of(context)!.agreements,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: AppLocalizations.of(context)!.settings,
      ),
    ];

    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const PropertiesScreen();
        break;
      case 1:
        body = Text('Remodelling');
        break;
      case 2:
        body = Text('Agreements');
        break;
      case 3:
        body = const SettingsPage();
        break;
      default:
        body = const PropertiesScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(options[_selectedIndex].label!),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: options,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
