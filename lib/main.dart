import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/property_screen.dart';
import 'package:tner_client/settings/settings.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'contracts/contracts.dart';
import 'owner/owner.dart';
import 'remodeling/remodeling_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper.ensureInitialized();

  runApp(ChangeNotifierProvider.value(
      value: SharedPreferencesHelper.changeNotifier, child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO check to see if orientation works on ipad
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Consumer<SharedPreferencesChangedNotifier>(
        builder: (context, _, child) {
      return MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const AppHome(),
          theme: SharedPreferencesHelper.isDarkMode()
              ? AppTheme.getDarkTheme()
              : AppTheme.getLightTheme(),
          locale: SharedPreferencesHelper.getLocale());
    });
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => AppHomeState();
}

class AppHomeState extends State<AppHome> {
  int _selectedIndex = 0; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          PropertyScreen(),
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
            label: S.of(context).property,
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
