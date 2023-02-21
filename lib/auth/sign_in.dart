import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/id.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.close),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
            SignInButton(
              Buttons.Email,
              text: S.of(context).sign_in_with_email,
              onPressed: () {},
            ),
            AuthStateListener<PhoneAuthController>(
                listener: (oldState, newState, controller) {
                  if (newState is SMSCodeSent) {
                    // setState(() {
                    //   child = SMSCodeInput(
                    //     onSubmit: (code) {
                    //       controller.verifySMSCode(
                    //         code,
                    //         verificationId: newState.verificationId,
                    //         confirmationResult: newState.confirmationResult,
                    //       );
                    //     },
                    //   );
                    // });
                  }
                  return null;
                },
                child: SignInButtonBuilder(
                    //todo button size
                    onPressed: () {},
                    icon: Icons.phone_android,
                    text: S.of(context).sign_in_with_sms,
                    backgroundColor: Colors.white10)),
            _getSeparator(context),
            // todo "create a free account"
            ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).create_a_free_account))
          ],
        ),
      ),
    );
  }

  Widget _getSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
