import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/auth_button.dart';
import 'package:tner_client/auth/email_check.dart';
import 'package:tner_client/auth/sms_auth.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/id.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  subtitleBuilder: (context, _) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(S.of(context).or_create_a_free_account),
                      ),
                  providers: [
                    GoogleProvider(clientId: Id.googleClientId),
                    FacebookProvider(clientId: Id.facebookClientId)
                  ],
                  action: AuthAction.signIn),
            ),
            AuthButton(
                icon: Icons.email,
                label: S.of(context).continue_with_email,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const EmailCheckScreen()))
                      .then((signedIn) =>
                          signedIn ? Navigator.of(context).pop() : null);
                }),
            AuthButton(
                icon: Icons.phone_android,
                label: S.of(context).continue_with_sms,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const SMSAuthScreen()))
                      .then((signedIn) =>
                          signedIn ? Navigator.of(context).pop() : null);
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) => SMSAuthDialog());
                }),
          ],
        ),
      ),
    );
  }
}
