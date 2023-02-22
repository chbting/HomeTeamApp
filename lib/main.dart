import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tner_client/auth/firebase_ui_localizations/localizations_overrides.dart';
import 'package:tner_client/firebase_options.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/home_screen.dart';
import 'package:tner_client/id.dart';
import 'package:tner_client/ui/color/color_schemes.g.dart';
import 'package:tner_client/ui/color/custom_color.g.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: Id.googleClientId),
    FacebookProvider(
        clientId: Id.facebookClientId,
        redirectUri: 'https://tnerserver.firebaseapp.com/__/auth/handler'),
    PhoneAuthProvider(),
  ]);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    //androidProvider: AndroidProvider.debug,
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
        builder: (innerContext, _, child) {
      return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          lightCustomColors = lightCustomColors.harmonized(lightScheme);

          // Repeat for the dark color scheme.
          darkScheme = darkDynamic.harmonized();
          darkCustomColors = darkCustomColors.harmonized(darkScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightScheme = lightColorScheme;
          darkScheme = darkColorScheme;
        }
        return MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FirebaseUIAuthLocalizationsOverrides.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightScheme,
              extensions: [lightCustomColors],
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkScheme,
              extensions: [darkCustomColors],
            ),
            themeMode: SharedPreferencesHelper.isDarkMode() //todo system
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: SharedPreferencesHelper.getLocale(),
            home: const HomeScreen());
      });
    });
  }
}
