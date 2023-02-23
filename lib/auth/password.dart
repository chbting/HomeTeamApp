import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget(
      {Key? key, required this.email, required this.isRegistration})
      : super(key: key);

  final String email;
  final bool isRegistration;

  @override
  Widget build(BuildContext context) {
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
                action: isRegistration? AuthAction.signUp : AuthAction.signIn,
                showAuthActionSwitch: false,
                subtitleBuilder: (context, _) => Text(email),
                email: email,
                providers: [EmailAuthProvider()]),
          ),
        ],
      ),
    );
  }
}
