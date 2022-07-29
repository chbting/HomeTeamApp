import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/properties_screen.dart';
import 'package:tner_client/settings/settings.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

import 'contracts/contracts.dart';
import 'generated/l10n.dart';
import 'owner/owner.dart';
import 'remodeling/remodeling_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.ensureInitialized();

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
    // TODO check to see if orientation works on ipad
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ValueListenableBuilder(
      valueListenable: SharedPreferencesHelper.themeNotifier,
      builder: (context, value, _) {
        return ValueListenableBuilder(
          valueListenable: SharedPreferencesHelper.localeNotifier,
          builder: (context, value, _) {
            return MaterialApp(
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: const AppHome(),
                theme: SharedPreferencesHelper().isDarkMode()
                    ? AppTheme.getDarkTheme()
                    : AppTheme.getLightTheme(),
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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          PropertiesScreen(),
          RemodelingScreen(),
          ContractsScreen(),
          OwnerScreen(),
          SettingsScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            label: S.of(context).properties,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.construction),
            label: S.of(context).remodeling,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: S.of(context).agreements,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_identity),
            label: S.of(context).owner,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: S.of(context).settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
