import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SignInScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.of(context).pop();
          }),
          EmailLinkSignInAction((context) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmailLinkSignInScreen(
                      actions: [
                        AuthStateChangeAction<SignedIn>((context, state) {
                          Navigator.of(context).pop();
                        }),
                      ],
                    )));
          }),
          VerifyPhoneAction((context, _) {
            //todo custom phone verification flow
          })
        ],
      ),
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
