import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tner_client/generated/l10n.dart';

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
          SignInButton(
            Buttons.Facebook,
            text: S.of(context).sign_in_with_facebook,
            shape: const StadiumBorder(),
            onPressed: () {
              _signInWithFacebook();
            },
          ),
          SignInButton(
            Buttons.Google,
            text: S.of(context).sign_in_with_google,
            shape: const StadiumBorder(),
            onPressed: () {
              _signInWithGoogle()
                  .then((credential) => _onVerificationSuccess(context))
                  .catchError((error) => _onVerificationFailed(context));
            },
          ),
          SignInButtonBuilder(
            icon: Icons.phone_android,
            text: S.of(context).sign_in_with_sms,
            //todo wording
            shape: const StadiumBorder(),
            backgroundColor: Colors.black26,
            onPressed: () {
              _signInWithPhoneNumber('+852 6368 4330'); //todo
            },
          ),
          SignInButton(
            Buttons.Email,
            text: S.of(context).sign_in_with_email,
            shape: const StadiumBorder(),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Future<UserCredential> _signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> _signInWithGoogle() async {
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

  /// [phoneNumber] format '+852 1234 5678'
  void _signInWithPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        FirebaseAuth.instance.signInWithCredential(credential)
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('$e');
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint('code sent!');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('codeAutoRetrievalTimeout!');
      },
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
