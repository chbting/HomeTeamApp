import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class PasswordAuthWidget extends StatelessWidget {
  const PasswordAuthWidget(
      {Key? key, required this.email, required this.showRegistrationUI})
      : super(key: key);

  final String email;
  final bool showRegistrationUI;

  @override
  Widget build(BuildContext context) {
    var subtitle = email;

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
                action:
                    showRegistrationUI ? AuthAction.signUp : AuthAction.signIn,
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
