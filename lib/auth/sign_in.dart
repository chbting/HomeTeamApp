import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/auth_button.dart';
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
        elevation: 0,
        leading: const CloseButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(S.of(context).sign_in,
                        style: Theme.of(context).textTheme.titleLarge))),
            AuthStateListener<OAuthController>(
              child: OAuthProviderButton(
                // or any other OAuthProvider
                provider: GoogleProvider(clientId: Id.googleClientId),
              ),
              listener: (oldState, newState, ctrl) {
                if (newState is SignedIn) {
                  Navigator.of(context).pop();
                }
                return null;
              },
            ),
            AuthStateListener<OAuthController>(
              child: OAuthProviderButton(
                // or any other OAuthProvider
                provider: FacebookProvider(clientId: Id.facebookClientId),
              ),
              listener: (oldState, newState, ctrl) {
                if (newState is SignedIn) {
                  Navigator.of(context).pop();
                }
                return null;
              },
            ),
            AuthButton(
                icon: Icons.email,
                label: S.of(context).sign_in_with_email,
                onPressed: () {}),
            AuthButton(
                icon: Icons.phone_android,
                label: S.of(context).sign_in_with_sms,
                onPressed: () {}),
            _getSeparator(context),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                child: Text(S.of(context).create_a_free_account))
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
