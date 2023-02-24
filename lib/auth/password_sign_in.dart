import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

class PasswordSignInWidget extends StatelessWidget {
  const PasswordSignInWidget(
      {Key? key, required this.email, required this.isRegistration})
      : super(key: key);

  final String email;
  final bool isRegistration;

  @override
  Widget build(BuildContext context) {
    var subtitle = email;
    if (isRegistration) {
      subtitle += ' ${S.of(context).is_registered_prompt_password_sign_in}';
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FirebaseUIActions(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  // Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.of(context).pop(true);
                }
              }),
            ],
            child: LoginView(
                action: AuthAction.signIn,
                showAuthActionSwitch: false,
                subtitleBuilder: (context, _) => Text(subtitle),
                email: email,
                providers: [EmailAuthProvider()]),
          ),
        ],
      ),
    );
  }
}
