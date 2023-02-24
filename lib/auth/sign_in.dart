import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/auth_button.dart';
import 'package:tner_client/auth/email_sign_in.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/id.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 24.0;
    const buttonHeight = 48.0;
    double buttonWidth =
        MediaQuery.of(context).size.width - horizontalPadding * 2;
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Colors.transparent,
          //elevation: 0,
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FirebaseUIActions(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (state.user != null) {
                    Navigator.of(context).pop();
                  }
                }),
              ],
              child: LoginView(
                  showAuthActionSwitch: false,
                  providers: [
                    GoogleProvider(clientId: Id.googleClientId),
                    FacebookProvider(clientId: Id.facebookClientId)
                  ],
                  action: AuthAction.signIn),
            ),
            AuthButton(
                icon: Icons.email,
                label: S.of(context).sign_in_with_email,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const EmailSignInScreen(fromRegistration: false)));
                }),
            AuthButton(
                icon: Icons.phone_android,
                label: S.of(context).sign_in_with_sms,
                onPressed: () {}),
            _getSeparator(context),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: Text(S.of(context).create_a_free_account),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const EmailSignInScreen(fromRegistration: true)));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _getSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(S.of(context).or,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const Expanded(child: Divider()),
      ]),
    );
  }
}
