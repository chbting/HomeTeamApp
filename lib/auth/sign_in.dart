import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FirebaseUILocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: _getCustomTheme(),
      locale: SharedPreferencesHelper.getLocale(),
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context).pop();
              }),
              EmailLinkSignInAction((context) {
                Navigator.pushReplacementNamed(context, '/email-link-sign-in');
              }),
              VerifyPhoneAction((context, _) {
                Navigator.pushNamed(context, '/phone');
              })
            ],
          );
        },
        '/email-link-sign-in': (context) => EmailLinkSignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.of(context).pop(); //todo pop causes black screen, consider ditching materialApp
                }),
              ],
            ),
        '/phone': (context) => PhoneInputScreen(actions: [
              //todo verification action
              SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SMSCodeInputScreen(
                      flowKey: flowKey,
                    ),
                  ),
                );
              }),
            ]),
      },
    );
  }

  ThemeData _getCustomTheme() {
    var theme = SharedPreferencesHelper.isDarkMode()
        ? AppTheme.getDarkTheme()
        : AppTheme.getLightTheme();
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8))));
  }
}
