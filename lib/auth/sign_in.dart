import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tner_client/auth/email_auth.dart';
import 'package:tner_client/auth/phone_auth.dart';
import 'package:tner_client/auth/sms_auth.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/id.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).sign_in),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        primary: false,
        children: [
          AuthStateListener<OAuthController>(
            child: OAuthProviderButton(
              provider: FacebookProvider(clientId: Id.facebookClientId),
            ),
            listener: (oldState, newState, ctrl) {
              if (newState is SignedIn) {
                _onVerificationSuccess(context);
              }
              return null;
            },
          ),
          AuthStateListener<OAuthController>(
            child: OAuthProviderButton(
              provider: GoogleProvider(clientId: Id.googleClientId),
            ),
            listener: (oldState, newState, ctrl) {
              if (newState is SignedIn) {
                _onVerificationSuccess(context);
              }
              return null;
            },
          ),
          SignInButtonBuilder(
            icon: Icons.phone_android,
            text: S.of(context).sign_in_with_sms,
            backgroundColor: Colors.black26,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PhoneAuth()));
            },
          ),
          SignInButtonBuilder(
            icon: Icons.phone_android,
            text: S.of(context).sign_in_with_sms,
            backgroundColor: Colors.black26,
            onPressed: () {
              showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return const SMSAuthDialog();
                      })
                  .then((signInSuccess) => signInSuccess
                      ? _onVerificationSuccess(context)
                      : _onVerificationFailed(context));
            },
          ),
          SignInButton(
            //todo rework the button, vertically center options
            Buttons.Email,
            text: S.of(context).sign_in_with_email,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const EmailAuth()))
                  .then((signInSuccess) =>
                      signInSuccess ? _onVerificationSuccess(context) : null);
            },
          )
        ],
      ),
    );
  }

  void _onVerificationSuccess(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onVerificationFailed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).msg_cannot_sign_in)));
  }
}
