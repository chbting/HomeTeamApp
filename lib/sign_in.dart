import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tner_client/generated/l10n.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  final buttonWidth = 300.0;
  final buttonHeight = 48.0;

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
          OutlinedButton.icon(
              icon: const Icon(Icons.email), //todo google icon
              label: Text(S.of(context).sign_in_with_google),
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                      width: 3.0, color: Theme.of(context).colorScheme.primary)),
              onPressed: () {
                signInWithGoogle();
              }),
          OutlinedButton.icon(
              icon: const Icon(Icons.email_outlined),
              label: Text(S.of(context).sign_in_with_email),
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  shape: const StadiumBorder()),
              onPressed: () {}),
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
